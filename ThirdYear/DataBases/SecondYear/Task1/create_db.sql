\c postgres;
DROP DATABASE IF EXISTS stationery_db;
CREATE DATABASE stationery_db;
\c stationery_db;

CREATE TABLE Suppliers
(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL UNIQUE,
	reg_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Staff
(
	id SERIAL PRIMARY KEY,
	full_name VARCHAR(40) NOT NULL,
	e_mail VARCHAR(30),
	reg_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Categories
(
	id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL UNIQUE,
  parent_category INT REFERENCES Categories(id)
);

CREATE TABLE Products
(
	id SERIAL PRIMARY KEY,
	category INT NOT NULL REFERENCES Categories(id),
	product_name VARCHAR(70) NOT NULL,
	supplier_id INT NOT NULL REFERENCES Suppliers(id),
  price FLOAT NOT NULL
);

CREATE TABLE Descriptions
(
	id SERIAL PRIMARY KEY,
	product_id INT NOT NULL REFERENCES Products(id),
	desc_name VARCHAR,
	desc_value VARCHAR
);

CREATE TABLE Sales
(
	id SERIAL PRIMARY KEY,
	staff_id INT NOT NULL REFERENCES Staff(id),
	product_id INT NOT NULL REFERENCES Products(id),
  quantity INT NOT NULL,
  sale_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Stores
(
	id SERIAL PRIMARY KEY,
	store_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Shelf
(
  id SERIAL PRIMARY KEY,
  product_id INT NOT NULL UNIQUE REFERENCES Products(id),
  quantity INT NOT NULL,
  store_id INT NOT NULL REFERENCES Stores(id)
);

CREATE TABLE Invoices
(
	id SERIAL PRIMARY KEY,
	staff_id INT NOT NULL REFERENCES Staff(id),
	name VARCHAR(10) NOT NULL,
  supplier_id INT NOT NULL REFERENCES Suppliers(id),
  product_id INT NOT NULL REFERENCES Products(id),
  quantity INT NOT NULL,
	price FLOAT NOT NULL,
	invoice_date DATE NOT NULL DEFAULT CURRENT_DATE
);

CREATE TABLE Invoice_Products
(
	id SERIAL PRIMARY KEY,
	invoice_id INT NOT NULL REFERENCES Invoices(id),
	product_id INT NOT NULL REFERENCES Products(id)
);

INSERT INTO Suppliers (name) VALUES ('Rath-Adams');
INSERT INTO Suppliers (name) VALUES ('Dooley-Hills');
INSERT INTO Suppliers (name) VALUES ('Deckow Group');
INSERT INTO Suppliers (name) VALUES ('Halvorson-Kohler');
INSERT INTO Suppliers (name) VALUES ('Parisian and Sons');
INSERT INTO Suppliers (name) VALUES ('Towne, Frami and Hand');
INSERT INTO Suppliers (name) VALUES ('Hilpert, Corkery and Hammes');
INSERT INTO Suppliers (name) VALUES ('Miller, Johnston and Graham');
INSERT INTO Suppliers (name) VALUES ('Sanford, Hodkiewicz and Hauck');
INSERT INTO Suppliers (name) VALUES ('O''Reilly, Daugherty and Bergnaum');

INSERT INTO Categories(name, parent_category) VALUES ('Pen', NULL);
INSERT INTO Categories(name, parent_category) VALUES ('Gel pen', 1);
INSERT INTO Categories(name, parent_category) VALUES ('Ball pen', 1);
INSERT INTO Categories(name, parent_category) VALUES ('Pencil', NULL);
INSERT INTO Categories(name, parent_category) VALUES ('Black pencil', 4);
INSERT INTO Categories(name, parent_category) VALUES ('Color pencil', 4);
INSERT INTO Categories(name, parent_category) VALUES ('Notebook', NULL);
INSERT INTO Categories(name, parent_category) VALUES ('Checkered notebook', 7);
INSERT INTO Categories(name, parent_category) VALUES ('Lined notebook', 7);
INSERT INTO Categories(name, parent_category) VALUES ('Lined notebook 24 papers', 9);
INSERT INTO Categories(name, parent_category) VALUES ('Lined notebook 48 papers', 9);
INSERT INTO Categories(name, parent_category) VALUES ('Workbook', 7);

INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('odio donec vitae nisi', 4, 4, 354.21);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('massa quis augue', 1, 1, 259.65);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('nullam orci', 7, 9, 432.39);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('in', 2, 7, 166.05);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('praesent blandit nam', 6, 2, 169.01);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('ut massa', 1, 5, 97.24);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('aliquam convallis nunc', 1, 9, 169.45);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('pretium iaculis diam', 10, 4, 159.87);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sapien iaculis congue vivamus', 2, 7, 228.42);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('ut massa volutpat convallis', 6, 6, 325.71);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('magnis dis parturient montes', 5, 9, 218.16);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('dolor', 1, 9, 207.96);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('a libero nam dui', 2, 5, 183.21);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('et ultrices', 11, 2, 125.91);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('purus aliquet at', 6, 2, 246.33);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('cursus vestibulum', 6, 5, 123.38);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('tellus in sagittis dui', 1, 6, 84.33);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sit amet erat', 4, 10, 471.79);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('vel dapibus', 2, 3, 188.39);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('hac habitasse', 7, 10, 109.01);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('duis at velit', 12, 9, 187.12);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('suspendisse ornare consequat', 10, 10, 94.44);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('faucibus orci luctus et', 6, 9, 441.7);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('maecenas tincidunt', 5, 7, 303.93);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sem sed sagittis', 10, 2, 440.09);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('eget nunc donec quis', 5, 5, 319.91);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('augue', 6, 7, 447.06);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('nascetur', 11, 1, 189.03);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('rhoncus aliquam lacus', 10, 8, 125.13);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('luctus cum sociis natoque', 7, 7, 253.29);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('vestibulum sed magna', 6, 1, 328.43);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('commodo placerat', 5, 8, 488.94);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('morbi vel lectus', 4, 10, 201.55);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('nulla nunc purus phasellus', 5, 6, 397.73);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('pede ullamcorper augue', 5, 2, 125.2);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('praesent id', 7, 1, 221.26);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('fermentum justo nec', 7, 10, 399.72);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('curae nulla dapibus dolor', 4, 10, 107.48);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('est', 3, 1, 478.18);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('in hac', 3, 7, 418.75);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('pretium quis lectus suspendisse', 5, 5, 371.22);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('vestibulum quam', 5, 6, 290.02);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('cras in purus eu', 6, 3, 465.98);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('vitae nisi nam', 4, 1, 315.65);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('quam pede lobortis ligula', 6, 8, 456.87);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('in faucibus orci luctus', 4, 8, 291.22);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('odio consequat varius', 5, 1, 201.4);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sapien a libero', 12, 6, 246.63);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('odio', 9, 9, 162.16);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('orci', 2, 8, 458.63);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('ultrices aliquet', 10, 8, 415.76);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('in', 6, 6, 238.18);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('erat fermentum', 7, 4, 151.17);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('phasellus', 6, 1, 223.06);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('nulla tellus in', 5, 1, 242.95);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('nisi volutpat eleifend donec', 6, 6, 328.08);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('fusce lacus purus', 10, 3, 244.18);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sit amet eleifend pede', 3, 10, 227.1);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('lectus vestibulum quam sapien', 7, 10, 255.59);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('cubilia curae nulla dapibus', 4, 2, 406.75);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('nec euismod', 8, 4, 223.8);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sapien sapien non mi', 10, 7, 302.47);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('hac habitasse platea', 3, 8, 66.24);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('proin', 4, 6, 221.36);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('donec', 2, 8, 63.85);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('dictumst aliquam', 3, 8, 109.82);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('at nibh', 1, 6, 149.05);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('in eleifend', 7, 8, 53.16);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('morbi non lectus', 6, 10, 283.81);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('in', 3, 3, 302.01);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sapien varius ut', 5, 5, 387.43);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('justo lacinia eget', 8, 6, 153.82);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('nulla', 1, 9, 266.95);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sit amet eros suspendisse', 10, 1, 437.63);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sapien quis libero', 6, 3, 410.53);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('pharetra magna', 8, 1, 463.33);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sit amet eleifend pede', 9, 4, 61.01);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('nulla tellus in', 2, 10, 379.54);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('sagittis', 8, 9, 163.12);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('diam erat fermentum justo', 7, 4, 114.03);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('rutrum at lorem integer', 8, 10, 234.0);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('vestibulum rutrum rutrum', 5, 6, 462.1);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('morbi', 10, 9, 301.87);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('vitae mattis nibh', 6, 10, 490.2);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('lectus pellentesque', 3, 7, 223.31);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('morbi', 3, 6, 191.95);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('primis in faucibus', 4, 8, 112.01);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('quis turpis eget elit', 2, 9, 214.35);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('mi pede', 5, 10, 355.45);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('tristique est', 1, 6, 373.96);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('mi integer ac neque', 8, 1, 142.62);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('habitasse', 4, 10, 425.59);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('semper rutrum', 7, 4, 119.64);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('erat fermentum justo', 1, 10, 482.64);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('id nisl venenatis lacinia', 3, 7, 489.47);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('pede libero', 7, 7, 120.45);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('enim sit amet nunc', 7, 10, 305.94);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('mi in porttitor pede', 3, 5, 386.2);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('ridiculus mus etiam vel', 3, 7, 327.93);
INSERT INTO Products (product_name, category, supplier_id, price) VALUES ('quis orci eget', 6, 8, 95.39);

-- Виведіть дерево категорій товарів з кількістю товарів на всіх рівнях.

WITH RECURSIVE recursive (id, path) AS (
  SELECT id, name FROM Categories WHERE parent_category IS NULL
  UNION ALL
  SELECT c.id, CONCAT(r.path, '/', c.name) FROM Categories c
  JOIN recursive r ON r.id = c.parent_category
)

SELECT r.id, r.path, COUNT(p.id) FROM recursive r
JOIN Products p ON p.category = r.id GROUP BY r.id, r.path
ORDER BY path;
