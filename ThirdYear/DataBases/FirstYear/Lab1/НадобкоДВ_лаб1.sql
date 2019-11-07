-- 1 Вивести за допомогою команди SELECT своє прізвище, ім’я та по-батькові на екран.
SELECT 'Nadobko' AS "Surname", 'Dmitriy' AS "Name", 'Valerievich' AS "Patronimic";

-- 2 Вибрати всі дані з таблиці Products.
SELECT * FROM products;

-- 3 Обрати всі назви продуктів з тієї ж таблиці, продаж яких припинено.
SELECT "ProductName" FROM products WHERE "Discontinued" = 0;

-- 4 Вивести всі міста клієнтів уникаючи дублікатів.
SELECT DISTINCT "City" FROM customers;

-- 5 Вибрати всі назви компаній-постачальників в порядку зворотньому алфавітному.
SELECT "CompanyName" FROM shippers ORDER BY "CompanyName" DESC;

-- 6 Отримати всі деталі замовлень, замінивши назви стовбчиків на їх порядковий номер.
SELECT "OrderID" AS "1", "ProductID" AS "2", "UnitPrice" AS "3", "Quantity" AS "4", "Discount" AS "5" FROM order_details;

-- 7 Вивести всі контактні імена клієнтів, що починаються з першої літери вашого прізвища, імені, по-батькові.
SELECT "ContactName" FROM customers WHERE "ContactName" LIKE 'N%' OR  "ContactName" LIKE 'D%' OR "ContactName" LIKE 'V%';

--8 Показати усі замовлення, в адресах доставки яких є пробіл.
SELECT * FROM orders WHERE "ShipAddress" LIKE '% %';

-- 9 Вивести назви тих продуктів, що починаються на знак % або _, а закінчуються на останню літеру вашого імені.
SELECT "ProductName" FROM products WHERE "ProductName" LIKE '\%%o' OR "ProductName" LIKE '\_%o';
