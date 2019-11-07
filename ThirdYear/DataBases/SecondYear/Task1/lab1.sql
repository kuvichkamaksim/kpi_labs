-- 1
-- Назва поставщика повинна бути унікальна у рамках назв товарів.
-- Тобто, наприклад поле SUPPLIER = ‘Lg’ не може бути у різних
-- Product (TV-10).

SELECT product, MIN(supplier) FROM store
  GROUP BY product
  HAVING COUNT(DISTINCT supplier) = 1
  ORDER BY product;

--INNER JOIN

-- SELECT DISTINCT s2.product, s2.supplier FROM
--   (SELECT product, COUNT(DISTINCT supplier) FROM store
--   GROUP BY product) s1
-- JOIN store s2 ON s1.product = s2.product
-- WHERE s1.count = 1
-- ORDER BY s2.product;

SELECT DISTINCT product, supplier FROM store
EXCEPT
SELECT DISTINCT a.product AS product,
                a.supplier AS supplier FROM store a
INNER JOIN
store b ON a.product = b.product WHERE b.supplier <> a.supplier;

-- 2
-- Максимальна кількість товарів на полиці STORE.SHELF – 30.
-- З урахуванням того, що STORE.QUANTITY – кількість товарів
-- на полиці STORE.SHELF.

SELECT shelf, sum(quantity::INTEGER) FROM store
  WHERE quantity ~ '\d+'
  GROUP BY shelf
  HAVING sum(quantity::INTEGER) <= 30;

-- 3
-- Діапазон дат: 01.01.2011 -  31.05.2014. Використайте
-- регулярні вирази.

SELECT * FROM invoice
  WHERE invoice_date ~ '([0-3][0-9].[0-1][0-9].201[1-3])|([0-3][0-9].0[1-5].2014)';

-- 4
-- Одному і тому ж значенню поля ID_STUFF повинні відповідати
-- одні й ті ж значення полів STUFF_NAME, E_MAIL таблиці INVOICE.

SELECT id_stuff, min(staff_name), min(e_mail) FROM invoice
  GROUP BY id_stuff
  HAVING COUNT(DISTINCT staff_name) = 1
    AND COUNT(DISTINCT e_mail) = 1
    ORDER BY id_stuff;

--INNER JOIN

-- SELECT DISTINCT i2.id_stuff, i2.staff_name, i2.e_mail FROM
--   (SELECT id_stuff, COUNT(DISTINCT staff_name) AS name, COUNT(DISTINCT e_mail) AS e_mail FROM invoice
--   GROUP BY id_stuff) i
-- JOIN invoice i2 ON i.id_stuff = i2.id_stuff
-- WHERE i.name = 1 AND i.e_mail = 1
-- ORDER BY i2.id_stuff;

SELECT DISTINCT id_stuff, staff_name, e_mail FROM invoice
EXCEPT
SELECT DISTINCT a.id_stuff,
                a.staff_name,
                a.e_mail FROM invoice a
INNER JOIN
invoice b ON a.id_stuff = b.id_stuff AND a.staff_name = b.staff_name WHERE a.e_mail <> b.e_mail
ORDER BY id_stuff;

-- 5
-- Типи операцій на складі – лише IN, OUT (незалежно від регістра).
-- Використайте регулярні вирази.

SELECT * FROM store
  WHERE oper_type ~* '^(in|out)$';
