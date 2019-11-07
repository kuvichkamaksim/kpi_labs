/* Створити збережену процедуру, що при виклику буде повертати ваше прізвище,
   ім’я та по-батькові. */

CREATE OR REPLACE PROCEDURE myFullName()
  SELECT 'Kuvichka Maksim Evhenovych';

/* В котексті бази Northwind створити збережену процедуру, що приймає текстовий
   параметр мінімальної довжини. У разі виклику процедури з параметром ‘F’ на
   екран виводяться усі співробітники-жінки, у разі використання параметру ‘M’ –
   чоловіки. У протилежному випадку вивести на екран повідомлення про те, що
   параметр не розпізнано. */

DELIMITER //

CREATE OR REPLACE PROCEDURE showEmployees(gender VARCHAR(1))
BEGIN
  IF gender = 'F' OR gender = 'f' THEN
    SELECT FirstName, LastName FROM Employees
      WHERE TitleOfCourtesy = 'Ms.' OR TitleOfCourtesy = 'Mrs.';

  ELSEIF gender = 'M' OR gender = 'm' THEN
    SELECT FirstName, LastName FROM Employees
      WHERE TitleOfCourtesy = 'Mr.' OR TitleOfCourtesy = 'Dr.';

  ELSE
    SELECT 'Message was not interpreted.';

  END IF;

END //

DELIMITER ;

CALL showEmployees('M');

/* В котексті бази Northwind створити збережену процедуру, що виводить усі
   замовлення за заданий період. В тому разі, якщо період не задано – вивести
   замовлення за поточний день. */

DELIMITER //

CREATE OR REPLACE PROCEDURE showOrdersInPeriod(startDate DATETIME,
  endDate DATETIME)
BEGIN

    IF endDate IS NULL THEN
      SELECT * FROM Orders
        WHERE OrderDate = startDate;

    ELSEIF startDate IS NULL THEN
      SELECT * FROM Orders
        WHERE OrderDate = endDate;

    ELSE
      SELECT * FROM Orders
        WHERE OrderDate BETWEEN startDate AND endDate;
    END IF;

END //
DELIMITER ;

CALL showOrdersInPeriod('1996-07-10 00:00:00.000', '1996-07-26 00:00:00.000');

/* В котексті бази Northwind створити збережену процедуру, що в залежності від
   переданого параметру категорії виводить категорію та перелік усіх продуктів
   за цією категорією. Дозволити можливість використати від однієї до п’яти
   категорій. */

DELIMITER //

CREATE OR REPLACE PROCEDURE selectProductsByCategory( category1 VARCHAR(15),
  category2 VARCHAR(15), category3 VARCHAR(15), category4 VARCHAR(15),
  category5 VARCHAR(15) )
BEGIN

  SELECT Products.ProductName,
    Categories.CategoryName FROM Products JOIN Categories
    ON Products.CategoryID = Categories.CategoryID
    WHERE Categories.CategoryName IN (category1, category2, category3,
                                      category4, category5);

END //

DELIMITER ;

CALL selectProductsByCategory('Seafood', NULL, 'Confections', 'Produce', NUll);

/* В котексті бази Northwind модифікувати збережену процедуру Ten Most Expensive
   Products для виводу всієї інформації з таблиці продуктів, а також імен
   постачальників та назви категорій. */

DELIMITER //

CREATE OR REPLACE PROCEDURE TenMostExpensiveProducts()
BEGIN

  SELECT Products.*, Shippers.CompanyName, Categories.CategoryName
  FROM Products
  JOIN Shippers ON Products.SupplierID = Shippers.ShipperID
  JOIN Categories ON Products.CategoryID = Categories.CategoryID
  ORDER BY UnitPrice DESC
  LIMIT 10;

END; //

DELIMITER ;

CALL TenMostExpensiveProducts();

/* В котексті бази Northwind створити функцію, що приймає три параметри
   (TitleOfCourtesy, FirstName, LastName) та виводить їх єдиним текстом.
   Приклад: ‘Dr.’, ‘Yevhen’, ‘Nedashkivskyi’ –> ‘Dr. Yevhen Nedashkivskyi’ */

CREATE OR REPLACE FUNCTION concatStrings( TitleOfCourtesy VARCHAR(20),
  FirstName VARCHAR(20), LastName VARCHAR(20) )
RETURNS VARCHAR(63) DETERMINISTIC
RETURN CONCAT(TitleOfCourtesy, ' ', FirstName, ' ', LastName);

SELECT concatStrings('Dr.', 'Yevhen', 'Nedashkivskyi');

/* В контексті бази Northwind створити функцію, що приймає три параметри
   (UnitPrice, Quantity, Discount) та виводить кінцеву ціну. */

DELIMITER //

CREATE OR REPLACE FUNCTION calculateFullPrice( UnitPrice FLOAT(5,2),
  Quantity INTEGER, Discount FLOAT(3,2) )
RETURNS FLOAT(10, 5)
IF Discount <= 1 AND Discount >= 0 THEN
  RETURN UnitPrice * Quantity * (1 - Discount);
END IF; //

DELIMITER ;

SELECT calculateFullPrice(3.2, 5, 0.2);

/* Створити функцію, що приймає параметр текстового типу і приводить його до
   Pascal Case. Приклад: Мій маленький поні –> МійМаленькийПоні */

DELIMITER //

CREATE OR REPLACE FUNCTION toPascalCase( string VARCHAR(30) )
RETURNS VARCHAR(30)
BEGIN
  DECLARE res VARCHAR(30) DEFAULT '';
  DECLARE pos INTEGER DEFAULT 1;
  DECLARE curr VARCHAR(1);
  SET string = LOWER(string);

  WHILE pos <= LENGTH(string)
  DO
    SET curr = SUBSTRING(string, pos, 1);
    IF curr REGEXP '^[A-Z]+$' = 1 THEN

      IF SUBSTRING(string, pos-1, 1) REGEXP '^[A-Z]+$' = 0 THEN
        SET res = CONCAT( res, UPPER(curr) );
      ELSE
        SET res = CONCAT( res, curr );
      END IF;

    END IF;
    SET pos = pos + 1;
  END WHILE;

 RETURN res;

END; //

DELIMITER ;

SELECT toPascalCase('My little pony');

/* В котексті бази Northwind створити функцію, що в залежності від вказаної
   країни, повертає усі дані про співробітникiв у вигляді таблиці. */

-- We can't return table from a function in mariaDB, so we'll use procedure.

DELIMITER //

CREATE OR REPLACE PROCEDURE findEmployeeFrom(country VARCHAR(15))
BEGIN
  SELECT * FROM Employees WHERE Country = country;
END;

DELIMITER ;

CALL findEmployeeFrom('US');
/* В котексті бази Northwind створити функцію, що в залежності від імені
   транспортної компанії повертає список клієнтів, якою вони обслуговуються. */

DELIMITER //

CREATE OR REPLACE PROCEDURE findClientsOfCompany(company VARCHAR(40))
BEGIN
 SELECT Customers.CompanyName FROM Customers
 JOIN Orders ON Customers.CustomerID = Orders.CustomerID
 JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID
 WHERE Shippers.CompanyName = company;
END; //

DELIMITER ;

CALL findClientsOfCompany('Speedy Express');
