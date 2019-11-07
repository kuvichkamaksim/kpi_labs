--Task №1

/* Bикористовуючи SELECT двічі, виведіть на екран своє ім’я, прізвище та по-батькові одним результуючим набором. */

SELECT "Kuvichka"
UNION
SELECT "Maksim Evhenovych";

/* Порівнявши власний порядковий номер в групі з набором із всіх номерів в групі, вивести на екран ;-) якщо він менший за усі з них, або :-D в протилежному випадку. */

SELECT CASE
    WHEN 15 < ALL(SELECT * FROM seq_1_to_31)
    THEN ";-)"
    ELSE ":-D"
    END;

/* Hе використовуючи таблиці, вивести на екран прізвище та ім’я усіх дівчат своєї групи за вийнятком тих, хто має спільне ім’я з студентками іншої групи. */

WITH IP71_girls AS (
    SELECT "Nastya" AS FirstName, "Kaspruk" AS LastName
    UNION
    SELECT "Diana" AS FirstName, "Bolotenyuk" AS LastName
    UNION
    SELECT "Olga" AS FirstName, "Orel" AS LastName
)
SELECT * FROM IP71_girls
EXCEPT
SELECT * FROM IP71_girls
WHERE IP71_girls.FirstName = ANY(
    SELECT "Sasha"
    UNION
    SELECT "Olesia"
    UNION
    SELECT "Nastya"
);

/* Bивести усі рядки з таблиці Numbers (Number INT). Замінити цифру від 0 до 9 на її назву літерами. Якщо цифра більше, або менша за названі, залишити її без змін. */

SELECT CASE
    WHEN number = 0 THEN "Zero"
    WHEN number = 1 THEN "One"
    WHEN number = 2 THEN "Two"
    WHEN number = 3 THEN "Three"
    WHEN number = 4 THEN "Four"
    WHEN number = 5 THEN "Five"
    WHEN number = 6 THEN "Six"
    WHEN number = 7 THEN "Seven"
    WHEN number = 8 THEN "Eight"
    WHEN number = 9 THEN "Nine"
    ELSE CAST(number AS CHAR(20))
    END
    FROM Numbers;

/* Hавести приклад синтаксису декартового об’єднання для вашої СУБД. */

-- In MariaDB any JOIN without an ON clause is a CROSS JOIN.

SELECT * FROM Region CROSS JOIN Shippers; /* SELECT * FROM Region JOIN Shippers; */

--Task №2

/* Bивeсти усі замовлення та їх службу доставки. В залежності від ідентифікатора служби доставки, переіменувати її на таку, що відповідає вашому імені, прізвищу, або по-батькові. */

SELECT OrderID, CASE
    WHEN ShipVia = 1 THEN "Maksim"
    WHEN ShipVia = 2 THEN "Evhenovych"
    ELSE "Kuvichka"
    END
    FROM Orders;

/* Bивести в алфавітному порядку усі країни, що фігурують в адресах клієнтів, працівників, та місцях доставки замовлень. */

SELECT DISTINCT Country AS "Country" FROM Customers UNION
    SELECT DISTINCT Country AS "Country"  FROM Employees UNION
    SELECT DISTINCT ShipCountry AS "Country" FROM Orders
    ORDER BY Country ASC;

/* Bивести прізвище та ім’я працівника, а також кількість замовлень, що він обробив за перший квартал 1998 року. */

SELECT FirstName, LastName, COUNT(*) AS "Orders number"
    FROM Employees
    JOIN Orders
        ON Employees.EmployeeID = Orders.EmployeeID
    WHERE QUARTER(OrderDate) = 1
        AND YEAR(OrderDate) = 1998
    GROUP BY FirstName, LastName;

/* Bикористовуючи СTE знайти усі замовлення, в які входять продукти, яких на складі більше 100 одиниць, проте по яким немає максимальних знижок. */

WITH resultItemsIDs AS (SELECT `Order Details`.OrderID
    FROM `Order Details`
    JOIN Products
        ON `Order Details`.ProductID = Products.ProductID
    WHERE Products.UnitsInStock > 100
    AND `Order Details`.Discount NOT IN(
	SELECT MAX(`Order Details`.Discount)
	FROM `Order Details`
    )
)
SELECT * FROM Orders
WHERE OrderID IN (SELECT * FROM resultItemsIDs);

/* Знайти назви усіх продуктів, що не продаються в південному регіоні. */

SELECT DISTINCT Products.ProductName FROM Orders
    JOIN `Order Details`
        ON Orders.OrderID = `Order Details`.OrderID
    JOIN Products
        ON `Order Details`.ProductID = Products.ProductID
    JOIN Employees
	ON Orders.EmployeeID = Employees.EmployeeID
    JOIN EmployeeTerritories
	ON Orders.EmployeeID = EmployeeTerritories.EmployeeID
    JOIN Territories
	ON EmployeeTerritories.TerritoryID = Territories.TerritoryID
    JOIN Region
	ON Territories.RegionID = Region.RegionID
    WHERE Orders.ShipRegion != 4
    ORDER BY ProductName;

