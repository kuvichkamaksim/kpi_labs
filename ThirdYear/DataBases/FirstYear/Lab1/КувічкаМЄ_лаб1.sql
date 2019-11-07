/* Вивести за допомогою команди SELECT своє прізвище, ім’я та по-батькові на екран. */
SELECT 'Кувічка Максим Євгенович';

/* Вибрати всі дані з таблиці Products. */
SELECT * FROM Products;

/* Обрати всі назви продуктів з тієї ж таблиці, продаж яких припинено. */
SELECT ProductName FROM Products WHERE Discontinued = 1;

/* Вивести всі міста клієнтів уникаючи дублікатів. */
SELECT DISTINCT City FROM Customers;

/* Вибрати всі назви компаній-постачальників в порядку зворотньому алфавітному. */
SELECT CompanyName FROM Suppliers ORDER BY CompanyName DESC;

/* Отримати всі деталі замовлень, замінивши назви стовбчиків на їх порядковий номер. */
SELECT OrderID AS '1', ProductID AS '2', UnitPrice AS '3', Quantity AS '4', Discount AS '5' FROM `Order Details`;

/* Bивести всі контактні імена клієнтів, що починаються з першої літери вашого прізвища, iменi, по-батькові. */
SELECT ContactName from Customers WHERE ContactName LIKE 'M%' OR ContactName LIKE 'm%' OR ContactName LIKE 'K%' OR ContactName LIKE 'k%' OR ContactName LIKE 'E%' OR ContactName LIKE 'e%' ORDER BY ContactName ASC;

/* Показати усі замовлення, в адресах доставки яких є пробіл. */
SELECT * FROM Orders WHERE ShipAddress LIKE '% %';

/* Bивести назви тих продуктів, що починаються на знак % або _, а закінчуються на останню літеру вашого імені. */
SELECT ProductName FROM Products WHERE ProductName LIKE '\%%m' OR ProductName LIKE '\_%m' OR ProductName LIKE '\%%M' OR ProductName LIKE '\_%M';
