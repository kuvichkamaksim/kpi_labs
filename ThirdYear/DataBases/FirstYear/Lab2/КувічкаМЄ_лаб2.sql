-- Task №1
/* Необхідно знайти кількість рядків в таблиці, що містить
 більше ніж 2147483647 записів. */

-- MSSQL: SELECT COUNT_BIG(*) FROM table;

-- MariaDB
SELECT COUNT(*) FROM table;

-- In MariaDB COUNT returns data type bigint

/* Пдрахувати довжину свого прізвища за допомогою SQL. */

SELECT LENGTH('Kuvichka');

/* У рядку з своїм прізвищем, іменем, та по-батькові замінити
 пробіли на знак ‘_’ (нижнє підкреслення). */

SELECT REPLACE('Kuvichka Maksim Evhenovych', ' ', '_');

/* Cтворити генератор імені електронної поштової скриньки, що шляхом
 конкатенації об’єднував би дві перші літери з колонки імені, та
 чотири перші літери з колонки прізвища користувача, що зберігаються
 в базі даних, а також домену з вашим прізвищем. */

SELECT CONCAT(
    SUBSTRING(FirstName, 1, 4),
    SUBSTRING(LastName, 1, 2),
    '@kuvichka.ua'
  )
  FROM Employees;

/* За допомогою SQL визначити, в який день тижня ви народилися. */

SELECT WEEKDAY('2000-12-16');

-- Task №2
/* Bивести усі дані по продуктам, їх категоріям, та постачальникам, навіть якщо останні з певних причин відсутні. */

SELECT * FROM Products
  LEFT OUTER JOIN Categories
    ON Categories.CategoryID = Products.CategoryID
  LEFT OUTER JOIN Suppliers
    ON Suppliers.SupplierID = Products.SupplierID;

/* Показати усі замовлення, що були зроблені в квітні 1988 року та не були відправлені. */

SELECT OrderDate FROM Orders WHERE OrderDate LIKE '1998-04-__%' AND ShippedDate IS NULL;

/* Відібрати усіх працівників, що відповідають за північний регіон. */

SELECT DISTINCT LastName, FirstName, Title FROM Employees
	INNER JOIN EmployeeTerritories ON Employees.EmployeeID = EmployeeTerritories.EmployeeID
	INNER JOIN Territories ON Territories.TerritoryID = EmployeeTerritories.TerritoryID
	INNER JOIN Region ON Region.RegionID = Territories.RegionID
	WHERE RegionDescription = 'Northern';

/* Bирахувати загальну вартість з урахуванням знижки усіх замовлень, що були здійснені на непарну дату. */

SELECT SUM(UnitPrice * Quantity * (1 - Discount)) AS 'Total Price' FROM `Order Details`
	INNER JOIN Orders ON `Order Details`.OrderID = Orders.OrderID
	WHERE MOD(DAY(Orders.OrderDate), 2) = 1;

/* Знайти адресу відправлення замовлення з найбільшою ціною
 (враховуючи усі позиції замовлення, їх вартість, кількість, та наявність знижки). */

SELECT ShipAddress FROM `Order Details`
	INNER JOIN Orders ON `Order Details`.OrderID = Orders.OrderID
	GROUP BY `Order Details`.OrderID
	ORDER BY SUM(UnitPrice * Quantity * (1 - Discount)) DESC
	LIMIT 1;
