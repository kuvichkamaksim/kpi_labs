/* Додати себе як співробітника компанії на позицію Intern. */

INSERT INTO Employees(LastName, FirstName, Title, Notes)
    VALUES('Kuvichka', 'Maksym', 'Intern', '');

/* Змінити свою посаду на Director. */

UPDATE Employees
SET Title = 'Director'
WHERE LastName = 'Kuvichka'
    AND FirstName = 'Maksym';

/* Cкопіювати таблицю Orders в таблицю OrdersArchive. */

CREATE TABLE OrdersArchive SELECT * FROM Orders;

/* Oчистити таблицю OrdersArchive. */

DELETE OrdersArchive.* FROM OrdersArchive;

/* Hе видаляючи таблицю OrdersArchive, наповнити її інформацією повторно. */

INSERT INTO OrdersArchive
    SELECT * FROM Orders;

/* З таблиці OrdersArchive видалити усі замовлення, що були зроблені замовниками із Берліну. */

DELETE FROM OrdersArchive
    WHERE CustomerID IN
    (SELECT CustomerID FROM Customers WHERE City = 'Berlin');

/* Bнести в базу два продукти з власним іменем та іменем групи. */

INSERT INTO Products(ProductName, Discontinued)
    VALUES ('Maksym Kuvichka', 0), ('IP-71', 0);

/* Помітити продукти, що не фігурують в замовленнях, як такі, що більше не виробляються. */

UPDATE Products
SET Discontinued = 1
WHERE ProductID NOT IN (
    SELECT DISTINCT ProductID FROM `Order Details`);

/* Bидалити таблицю OrdersArchive. */

DROP TABLE OrdersArchive;

/* Bидатили базу Northwind. */

DROP DATABASE northwind;

