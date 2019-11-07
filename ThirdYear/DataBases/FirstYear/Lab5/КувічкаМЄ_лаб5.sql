/* Створити базу даних з ім’ям, що відповідає вашому прізвищу англійською мовою. */

CREATE DATABASE Kuvichka;

/* Створити в новій базі таблицю Student з атрибутами StudentId, SecondName, FirstName, Sex. Обрати для них оптимальний тип даних в вашій СУБД. */

CREATE TABLE Student (
	StudentId INT NOT NULL,
	SecondName VARCHAR(30) NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	Sex VARCHAR(1) NOT NULL
);

/* Модифікувати таблицю Student. Атрибут StudentId має стати первинним ключем. */

ALTER TABLE Student ADD PRIMARY KEY (StudentId);

/* Модифікувати таблицю Student. Атрибут StudentId повинен заповнюватися автоматично починаючи з 1 і кроком в 1. */

ALTER TABLE Student MODIFY StudentId INT NOT NULL AUTO_INCREMENT;

/* Модифікувати таблицю Student. Додати необов’язковий атрибут BirthDate за відповідним типом даних. */

ALTER TABLE Student ADD BirthDate DATE;

/* Модифікувати таблицю Student. Додати атрибут CurrentAge, що генерується автоматично на базі існуючих в таблиці даних. */

ALTER TABLE Student ADD CurrentAge TINYINT UNSIGNED AS ( TIMESTAMPDIFF(YEAR, Student.BirthDate, CURDATE()) ) VIRTUAL;

/* Реалізувати перевірку вставлення даних. Значення атрибуту Sex може бути тільки ‘m’ та ‘f’. */

ALTER TABLE Student ADD CHECK (Sex = 'm' OR Sex = 'f');

/* В таблицю Student додати себе та двох «сусідів» у списку групи. */

INSERT INTO Student (FirstName, SecondName, Sex, BirthDate)
	VALUES ("Valentyn", "Krasnyukevich", 'm', NULL),
	       ("Maksym", "Kuvichka", 'm', "2000-12-16"),
	       ("Illia", "Laska", 'f', "1999-03-01");

/* Створити  представлення vMaleStudent та vFemaleStudent, що надають відповідну інформацію. */

CREATE VIEW vMaleStudent AS
SELECT * FROM Student
WHERE Sex = 'm';

CREATE VIEW vFemaleStudent AS
SELECT * FROM Student
WHERE Sex = 'f';

/* Змінити тип даних первинного ключа на TinyInt (або SmallInt) не втрачаючи дані. */

ALTER TABLE Student MODIFY StudentId TINYINT NOT NULL AUTO_INCREMENT;
