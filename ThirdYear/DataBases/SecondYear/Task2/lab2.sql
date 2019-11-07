-- Task 1
-- Показати ранг кожного товару у групі/категорії (відповідно до зменшення ціни в групі).
-- Запит реалізувати через функції RANK() та DENSE_RANK().
-- Порівняти результати виконання. Крім того сформуйте запит без використання аналітичних функцій.

SELECT id_product_type,
       product_name,
       price,
       RANK() OVER( -- Пропускает ранги при повторах
         PARTITION BY id_product_type
         ORDER BY price DESC
       )price_rank
FROM product;

SELECT id_product_type, --RANK
       product_name,
       price,
       (SELECT
         COUNT(*) + 1
         FROM
           product p2
         WHERE p2.id_product_type = p.id_product_type AND
               p2.price > p.price
       ) AS price_rank
FROM product p
ORDER BY p.id_product_type, price_rank;

SELECT id_product_type,
       product_name,
       price,
       DENSE_RANK() OVER( -- Не пропускает ранги при повторах
         PARTITION BY id_product_type
         ORDER BY price DESC
       )price_rank
FROM product;

SELECT id_product_type, --DENSE_RANK
       product_name,
       price,
       (SELECT
         COUNT(DISTINCT price) + 1
         FROM
           product p2
         WHERE p2.id_product_type = p.id_product_type AND
               p2.price > p.price
       ) AS price_rank
FROM product p
ORDER BY p.id_product_type, price_rank;

-- Task 2
-- За допомогою аналітичного SQL сформуйте запит для виведення списку із трьох
-- найдешевших товарів у кожній групі.
-- Крім того сформуйте запит без використання аналітичних функцій.

SELECT * FROM(
  SELECT id_product_type,
         product_name,
         price,
         DENSE_RANK() OVER(
           PARTITION BY id_product_type
           ORDER BY price
         )price_rank
  FROM product) AS RANK
WHERE RANK.price_rank <= 3;

-- without analytical functions

SELECT * FROM(
  SELECT id_product_type,
         product_name,
         price,
         (SELECT
           COUNT(DISTINCT price) + 1
           FROM
             product p2
           WHERE p2.id_product_type = p.id_product_type AND
                 p2.price < p.price
         ) AS price_rank
  FROM product p) AS RANK
WHERE RANK.price_rank <= 3;

-- Task 3
-- F1 – продукти по яким здійснюються продажі, f2 – номер місяця,
-- f3 – продажі по товару за певний місяць 2012 року, f4 – продажі по товару за
-- певний місяць 2013 року, f5 – наростаючий підсумок продажів по товару за певний
-- місяць 2012 року, f5 – наростаючий підсумок продажів по товару за певний
-- місяць 2013 року. Крім того сформуйте запит без використання аналітичних функцій.

WITH invoices_2012 AS (
  SELECT id_product, SUM(quantity) AS quant, EXTRACT(MONTH FROM i.purchase_time) AS month
  FROM invoice i
  JOIN invoice_detail idet
    ON i.id_invoice = idet.id_invoice
  WHERE EXTRACT(YEAR FROM i.purchase_time) = 2012
  GROUP BY id_product, month
  ORDER BY id_product, month
),
invoices_2013 AS (
  SELECT id_product, SUM(quantity) AS quant, EXTRACT(MONTH FROM i.purchase_time) AS month
  FROM invoice i
  JOIN invoice_detail idet
    ON i.id_invoice = idet.id_invoice
  WHERE EXTRACT(YEAR FROM i.purchase_time) = 2013
  GROUP BY id_product, month
  ORDER BY id_product, month
)

SELECT p.product_name,
       curr_m,
       COALESCE(i2012.quant * p.price, 0) AS "2012",
       COALESCE(i2013.quant * p.price, 0) AS "2013",
       SUM(COALESCE(i2012.quant * p.price, 0)) OVER(
         PARTITION BY p.product_name
         ORDER BY curr_m
       ) Analytic_2012,
       SUM(COALESCE(i2013.quant * p.price, 0)) OVER(
         PARTITION BY p.product_name
         ORDER BY curr_m
       ) Analytic_2013
FROM product p
CROSS JOIN generate_series(1, 12) curr_m
LEFT JOIN invoices_2012 i2012 ON i2012.month = curr_m AND i2012.id_product = p.id_product
LEFT JOIN invoices_2013 i2013 ON i2013.month = curr_m AND i2013.id_product = p.id_product
ORDER BY p.product_name, curr_m;

-- without analytical functions

WITH invoices_2012 AS (
  SELECT id_product, SUM(quantity) AS quant, EXTRACT(MONTH FROM i.purchase_time) AS month
  FROM invoice i
  JOIN invoice_detail idet
    ON i.id_invoice = idet.id_invoice
  WHERE EXTRACT(YEAR FROM i.purchase_time) = 2012
  GROUP BY id_product, month
  ORDER BY id_product, month
),
invoices_2013 AS (
  SELECT id_product, SUM(quantity) AS quant, EXTRACT(MONTH FROM i.purchase_time) AS month
  FROM invoice i
  JOIN invoice_detail idet
    ON i.id_invoice = idet.id_invoice
  WHERE EXTRACT(YEAR FROM i.purchase_time) = 2013
  GROUP BY id_product, month
  ORDER BY id_product, month
)

SELECT p.product_name,
       curr_m,
       COALESCE(i2012.quant * p.price, 0) AS "2012",
       COALESCE(i2013.quant * p.price, 0) AS "2013",
       (SELECT SUM(COALESCE(i2012_2.quant * p2.price, 0))
        FROM product p2
        CROSS JOIN generate_series(1, 12) curr_m_2
        LEFT JOIN invoices_2012 i2012_2 ON i2012_2.month = curr_m_2 AND i2012_2.id_product = p2.id_product
        WHERE p2.product_name = p.product_name AND
              curr_m_2 <= curr_m
       ) AS Analytic_2012,
       (SELECT SUM(COALESCE(i2013_2.quant * p2.price, 0))
        FROM product p2
        CROSS JOIN generate_series(1, 12) curr_m_2
        LEFT JOIN invoices_2013 i2013_2 ON i2013_2.month = curr_m_2 AND i2013_2.id_product = p2.id_product
        WHERE p2.product_name = p.product_name AND
              curr_m_2 <= curr_m
       ) AS Analytic_2013
FROM product p
CROSS JOIN generate_series(1, 12) curr_m
LEFT JOIN invoices_2012 i2012 ON i2012.month = curr_m AND i2012.id_product = p.id_product
LEFT JOIN invoices_2013 i2013 ON i2013.month = curr_m AND i2013.id_product = p.id_product
ORDER BY p.product_name, curr_m;

-- Task 4
-- Показати, які товари по кожній групі мають найбільші та найменші продажі.
-- Крім того сформуйте запит без використання аналітичних функцій.

SELECT DISTINCT RANK.product_type_name,
                RANK.product_name,
                (CASE
                  WHEN RANK.category_max = 1 then 'biggest sales'
                  else 'smallest sales'
                end)
FROM (
  SELECT pn.product_type_name,
         p.product_name,
         SUM(p.price * i.quantity),
         RANK() OVER(
           PARTITION BY pn.product_type_name
           ORDER BY SUM(p.price * i.quantity) DESC
         ) category_max,
         RANK() OVER(
           PARTITION BY pn.product_type_name
           ORDER BY SUM(p.price * i.quantity)
         ) category_min
  FROM product p
  JOIN invoice_detail i
    ON p.id_product = i.id_product
  JOIN product_type pn
    ON p.id_product_type = pn.id_product_type
  GROUP BY pn.product_type_name, p.product_name
  ORDER BY pn.product_type_name, p.product_name
  ) AS RANK
WHERE RANK.category_max = 1 OR RANK.category_min = 1;

-- without analytical functions

SELECT DISTINCT RANK.product_type_name,
                RANK.product_name,
                (CASE
                  WHEN RANK.category_max = 1 THEN 'biggest sales'
                  ELSE 'smallest sales'
                END)
FROM (
  SELECT pn.product_type_name,
         p.product_name,
         SUM(p.price * i.quantity),

         (SELECT
           COUNT(*) + 1
           FROM
           (SELECT p2.product_name FROM
             product p2
           JOIN invoice_detail i2
             ON p2.id_product = i2.id_product
           JOIN product_type pn2
             ON p2.id_product_type = pn2.id_product_type
           WHERE pn2.product_type_name = pn.product_type_name
           GROUP BY p2.product_name
           HAVING SUM(p2.price * i2.quantity) > SUM(p.price * i.quantity)) a
         ) AS category_max,
         (SELECT
           COUNT(*) + 1
           FROM
           (SELECT p2.product_name FROM
             product p2
           JOIN invoice_detail i2
             ON p2.id_product = i2.id_product
           JOIN product_type pn2
             ON p2.id_product_type = pn2.id_product_type
           WHERE pn2.product_type_name = pn.product_type_name
           GROUP BY p2.product_name
           HAVING SUM(p2.price * i2.quantity) < SUM(p.price * i.quantity)) a
         ) AS category_min
  FROM product p
  JOIN invoice_detail i
    ON p.id_product = i.id_product
  JOIN product_type pn
    ON p.id_product_type = pn.id_product_type
  GROUP BY pn.product_type_name, p.product_name
  ORDER BY pn.product_type_name, p.product_name
  ) AS RANK
WHERE RANK.category_max = 1 OR RANK.category_min = 1;

-- Task 5
-- По кожному товару підрахувати кількість товарів, у яких вартість вища від
-- даного товару у діапазоні від 5 до 10 включно. Наприклад якщо прайс товару 6,
-- то знайти кількість товарів, у яких діапазон прайсів від 11 до 16.

SELECT product_name,
       price,
       COUNT(*) OVER(
         ORDER BY price
         RANGE BETWEEN 5 FOLLOWING AND 10 FOLLOWING
       )
FROM product
ORDER BY price;

-- Task 6
-- По кожному товару вивести першу(f3) та останню(f4) дату продажів по
-- кожному місяцю, cуму продажів (f5), відсоток від річної суми(f6).

WITH invoices_2013 AS (
  SELECT id_product,
         SUM(quantity) AS quant,
         EXTRACT(MONTH FROM i.purchase_time) AS month,
         MIN(i.purchase_time) AS first,
         MAX(i.purchase_time) AS last
  FROM invoice i
  JOIN invoice_detail idet
    ON i.id_invoice = idet.id_invoice
  WHERE EXTRACT(YEAR FROM i.purchase_time) = 2013
  GROUP BY id_product, month
  ORDER BY id_product, month
)

SELECT p.product_name,
       curr_m,
       i.first,
       i.last,
       COALESCE(SUM(i.quant * p.price) OVER(
         PARTITION BY p.id_product
         ORDER BY curr_m
       ), 0) s2013,
       concat(ROUND(COALESCE(SUM(i.quant * p.price) OVER(
         PARTITION BY p.id_product
         ORDER BY curr_m
       ), 0) /
       COALESCE(SUM(i.quant * p.price) OVER(
         PARTITION BY p.id_product
       ), 1) * 100, 2), '%') p2013
FROM product p
CROSS JOIN generate_series(1, 12) curr_m
LEFT JOIN invoices_2013 i ON i.month = curr_m AND i.id_product = p.id_product
ORDER BY p.product_name, curr_m;

-- Task 7
-- За допомогою ROLLUP та CUBE виведіть проміжні суми продажу по групам товарів.

SELECT pt.product_type_name, p.product_name, SUM(i.quantity * p.price)
FROM product p
JOIN product_type pt
  ON p.id_product_type = pt.id_product_type
JOIN invoice_detail i
  ON p.id_product = i.id_product
GROUP BY ROLLUP (pt.product_type_name, p.product_name)
ORDER BY pt.product_type_name, p.product_name;

SELECT p.product_name, EXTRACT(YEAR FROM i.purchase_time) AS year, SUM(idet.quantity * p.price)
FROM product p
JOIN invoice_detail idet
  ON p.id_product = idet.id_product
JOIN invoice i
  ON i.id_invoice = idet.id_invoice
GROUP BY CUBE (p.product_name, EXTRACT(YEAR FROM i.purchase_time))
ORDER BY p.product_name, year;
