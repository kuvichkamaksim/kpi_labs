/* Вивести на екран імена усіх таблиць в базі даних та кількість рядків в них. */

SELECT TABLE_NAME, TABLE_ROWS FROM information_schema.TABLES
  WHERE TABLE_SCHEMA = "northwind"
    AND TABLE_TYPE = "BASE TABLE";

/* Видати дозвіл на читання бази даних Northwind усім користувачам вашої СУБД.
   Код повинен працювати в незалежності від імен існуючих користувачів. */

DELIMITER //

CREATE PROCEDURE grantUsers()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE userName VARCHAR(30);
  DECLARE currentUser CURSOR FOR SELECT DISTINCT User FROM mysql.user;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN currentUser;

  read_loop: LOOP
    FETCH currentUser INTO userName;

    IF done THEN
      LEAVE read_loop;
    END IF;

    EXECUTE IMMEDIATE CONCAT('GRANT SELECT ON northwind.* TO ', userName);
  END LOOP;

  CLOSE currentUser;
END //
DELIMITER ;

CALL grantUsers();

/* За допомогою курсору заборонити користувачеві TestUser доступ до всіх таблиць
   поточної бази даних, імена котрих починаються на префікс ‘prod_’. */

DELIMITER //

CREATE PROCEDURE denyTestUser()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE tableName VARCHAR(30);
  DECLARE currentTable CURSOR FOR SELECT DISTINCT TABLE_NAME FROM information_schema.TABLES
    WHERE TABLE_SCHEMA = "northwind" AND TABLE_TYPE = "BASE TABLE" AND TABLE_NAME LIKE 'prod\_%';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN currentTable;

  read_loop: LOOP
    FETCH currentTable INTO tableName;

    IF done THEN
      LEAVE read_loop;
    END IF;

    EXECUTE IMMEDIATE CONCAT('REVOKE SELECT, DELETE, UPDATE ON nortthwind.', tableName, ' TO TestUser');
  END LOOP;
END //
DELIMITER ;

CALL denyTestUser();

/* Створити тригер на таблиці Customers, що при вставці нового телефонного
   номеру буде видаляти усі символи крім цифер. */

CREATE OR REPLACE TRIGGER checkPhone
  BEFORE INSERT ON Customers
  FOR EACH ROW
  SET NEW.Phone = REGEXP_REPLACE(NEW.Phone, '[^0-9]', '');

/* Створити таблицю Contacts (ContactId, LastName, FirstName, PersonalPhone,
   WorkPhone, Email, PreferableNumber). Створити тригер, що при вставці даних в
   таблицю Contacts вставить в якості PreferableNumber WorkPhone якщо він
   присутній, або PersonalPhone, якщо робочий номер телефона не вказано. */

CREATE TABLE Contacts(
	ContactId INT NOT NULL AUTO_INCREMENT,
	LastName VARCHAR(30) NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	PersonalPhone VARCHAR(20) NOT NULL,
	WorkPhone VARCHAR(20),
	Email VARCHAR(30),
	PreferableNumber VARCHAR(20) NOT NULL,
  CONSTRAINT `PK_Contacts` PRIMARY KEY (`ContactId`)
);

DELIMITER //

CREATE OR REPLACE TRIGGER setPreferablePhone
  BEFORE INSERT ON Contacts
  FOR EACH ROW
  BEGIN
    IF NEW.WorkPhone IS NOT NULL THEN
      SET NEW.PreferableNumber = NEW.WorkPhone;
    ELSE
      SET NEW.PreferableNumber = NEW.PersonalPhone;
    END IF;
  END //

DELIMITER ;

/* Створити таблицю OrdersArchive що дублює таблицію Orders та має додаткові
   атрибути DeletionDateTime та DeletedBy.
   Створити тригер, що при видаленні рядків з таблиці Orders буде додавати їх в
   таблицю OrdersArchive та заповнювати відповідні колонки. */

DROP TABLE IF EXISTS OrdersArchive;
CREATE TABLE OrdersArchive LIKE Orders;
ALTER TABLE OrdersArchive ADD DeletionDateTime DATETIME;
ALTER TABLE OrdersArchive ADD DeletedBy INTEGER;

DELIMITER //

CREATE OR REPLACE TRIGGER storeDeletedInfo
  AFTER DELETE ON Orders
  FOR EACH ROW
  BEGIN
    INSERT INTO OrdersArchive(OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight,
                               ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode, ShipCountry,
                               DeletionDateTime, DeletedBy)
    VALUES(OLD.OrderID, OLD.CustomerID, OLD.EmployeeID, OLD.OrderDate, OLD.RequiredDate, OLD.ShippedDate, OLD.ShipVia,
            OLD.Freight, OLD.ShipName, OLD.ShipAddress, OLD.ShipCity, OLD.ShipRegion, OLD.ShipPostalCode,
            OLD.ShipCountry, NOW(), CURRENT_USER());
  END; //

DELIMITER ;

/* Створити три таблиці: TriggerTable1, TriggerTable2 та TriggerTable3.
   Кожна з таблиць має наступну структуру: TriggerId(int) – первинний ключ з
   автоінкрементом, TriggerDate(Date).
   Створити три тригера. Перший тригер повинен при будь-якому записі в таблицю
   TriggerTable1 додати дату запису в таблицю TriggerTable2. Другий тригер
   повинен при будь-якому записі в таблицю TriggerTable2 додати дату запису в
   таблицю TriggerTable3. Третій тригер працює аналогічно за таблицями
   TriggerTable3 та TriggerTable1. Вставте один рядок в таблицю TriggerTable1.
   Напишіть, що відбулось в коментарі до коду. Чому це сталося? */

CREATE TABLE TriggerTable1(
  TriggerId INTEGER AUTO_INCREMENT,
  TriggerDate DATE,
  PRIMARY KEY (`TriggerId`)
);

CREATE TABLE TriggerTable2 LIKE TriggerTable1;
CREATE TABLE TriggerTable3 LIKE TriggerTable1;

DELIMITER //

CREATE OR REPLACE TRIGGER trig1
  AFTER INSERT ON TriggerTable1
  FOR EACH ROW
  BEGIN
    INSERT INTO TriggerTable2(TriggerDate)
    VALUES (NOW());
  END;

CREATE OR REPLACE TRIGGER trig2
  AFTER INSERT ON TriggerTable2
  FOR EACH ROW
  BEGIN
    INSERT INTO TriggerTable3(TriggerDate)
    VALUES (NOW());
  END;

CREATE OR REPLACE TRIGGER trig3
  AFTER INSERT ON TriggerTable3
  FOR EACH ROW
  BEGIN
    INSERT INTO TriggerTable1(TriggerDate)
    VALUES (NOW());
  END;

DELIMITER ;

INSERT INTO TriggerTable1(TriggerDate) VALUES (NOW());

/* ERROR 1442 (HY000): Can't update table 'TriggerTable1' in stored function/trigger because it is already used by
   statement which invoked this stored function/trigger */

/* Тригери нескінченно провокують один одного, а в СКБД передбачено захист від нескінченних циклів, тому вилітає
   помилка, щоб уникнути таких ситуацій.
 */
