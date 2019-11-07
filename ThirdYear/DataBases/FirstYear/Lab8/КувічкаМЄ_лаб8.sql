CREATE OR REPLACE DATABASE LazyStudent;
USE LazyStudent;

CREATE OR REPLACE TABLE Subjects(
  `SubjectID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `SubjectName` VARCHAR(20) NOT NULL,
  `Price` FLOAT(6, 2) NOT NULL
);

CREATE OR REPLACE TABLE Subjects_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `SubjectID` INTEGER NOT NULL,
  `SubjectName` VARCHAR(20) NOT NULL,
  `Price` FLOAT(6, 2) NOT NULL
);

CREATE OR REPLACE TABLE Users(
  `UserID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `UserType` VARCHAR(6) NOT NULL,
  `Login` VARCHAR(30) NOT NULL,
  `Password` VARCHAR(30) NOT NULL,
  `PhoneNumber` VARCHAR(15) NOT NULL,
  `E-mail` VARCHAR(30),
  `ReservePhoneNumber` VARCHAR(15)
);

CREATE OR REPLACE TABLE Users_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `UserID` INTEGER NOT NULL,
  `UserType` VARCHAR(6) NOT NULL,
  `Login` VARCHAR(30) NOT NULL,
  `Password` VARCHAR(30) NOT NULL,
  `PhoneNumber` VARCHAR(15) NOT NULL,
  `E-mail` VARCHAR(30),
  `ReservePhoneNumber` VARCHAR(15)
);

CREATE OR REPLACE TABLE Courses(
  `CourseID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `CourseName` VARCHAR(30) NOT NULL,
  `Price` FLOAT(6, 2) NOT NULL
);

CREATE OR REPLACE TABLE Courses_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `CourseID` INTEGER NOT NULL,
  `CourseName` VARCHAR(30) NOT NULL,
  `Price` FLOAT(6, 2) NOT NULL
);

CREATE OR REPLACE TABLE Clients(
  `ClientID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `LastName` VARCHAR(30) NOT NULL,
  `FirstName` VARCHAR(20) NOT NULL,
  `RegisterDate` DATETIME NOT NULL DEFAULT NOW(),
  `UserID` INTEGER NOT NULL DEFAULT 0,
  CONSTRAINT `FK_Clients`
    FOREIGN KEY (`UserID`) REFERENCES Users (`UserID`)
);

CREATE OR REPLACE TABLE Clients_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `ClientID` INTEGER NOT NULL,
  `LastName` VARCHAR(30) NOT NULL,
  `FirstName` VARCHAR(20) NOT NULL,
  `RegisterDate` DATETIME NOT NULL DEFAULT NOW(),
  `UserID` INTEGER NOT NULL DEFAULT 0
);

CREATE OR REPLACE TABLE Tutors(
  `TutorID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `FirstName` VARCHAR(20) NOT NULL,
  `LastName` VARCHAR(30) NOT NULL,
  `Rating` TINYINT UNSIGNED DEFAULT NULL,
  `UserID` INTEGER NOT NULL DEFAULT 0,
  CONSTRAINT `FK_Tutors`
    FOREIGN KEY (`UserID`) REFERENCES Users (`UserID`),
  CHECK (Rating < 100)
);

CREATE OR REPLACE TABLE Tutors_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `TutorID` INTEGER NOT NULL,
  `FirstName` VARCHAR(20) NOT NULL,
  `LastName` VARCHAR(30) NOT NULL,
  `Rating` TINYINT UNSIGNED DEFAULT NULL,
  `UserID` INTEGER NOT NULL DEFAULT 0
);

CREATE OR REPLACE TABLE Rating(
  `RecordID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `ClientID` INTEGER NOT NULL,
  `TutorID` INTEGER NOT NULL,
  `Rating` TINYINT UNSIGNED DEFAULT NULL,
  UNIQUE KEY(`TutorID`, `ClientID`),
  CONSTRAINT `FK_Rating`
    FOREIGN KEY (`TutorID`) REFERENCES Tutors (`TutorID`),
    FOREIGN KEY (`ClientID`) REFERENCES Clients (`ClientID`)
);

CREATE OR REPLACE TABLE Rating_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `RecordID` INTEGER NOT NULL,
  `ClientID` INTEGER NOT NULL,
  `TutorID` INTEGER NOT NULL,
  `Rating` TINYINT UNSIGNED DEFAULT NULL
);

CREATE OR REPLACE TABLE Lessons(
  `LessonID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `TutorID` INTEGER NOT NULL,
  `SubjectID` INTEGER NOT NULL,
  UNIQUE KEY(`TutorID`, `SubjectID`),
  CONSTRAINT `FK_Lessons`
    FOREIGN KEY (`TutorID`) REFERENCES Tutors (`TutorID`),
    FOREIGN KEY (`SubjectID`) REFERENCES Subjects (`SubjectID`)
);

CREATE OR REPLACE TABLE Lessons_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `LessonID` INTEGER NOT NULL,
  `TutorID` INTEGER NOT NULL,
  `SubjectID` INTEGER NOT NULL
);

CREATE OR REPLACE TABLE Companies(
  `CompanyID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `CompanyName` VARCHAR(40) NOT NULL,
  `PhoneNumber` VARCHAR(15) NOT NULL,
  `E-mail` VARCHAR(30),
  `ReservePhoneNumber` VARCHAR(15),
  `CourseID` INTEGER NOT NULL,
  CONSTRAINT `FK_Company`
    FOREIGN KEY (`CourseID`) REFERENCES Courses (`CourseID`)
);

CREATE OR REPLACE TABLE Companies_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `CompanyID` INTEGER NOT NULL,
  `CompanyName` VARCHAR(40) NOT NULL,
  `PhoneNumber` VARCHAR(15) NOT NULL,
  `E-mail` VARCHAR(30),
  `ReservePhoneNumber` VARCHAR(15),
  `CourseID` INTEGER NOT NULL
);

CREATE OR REPLACE TABLE Discounts(
  `DiscountID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `DiscountValue` FLOAT(3, 2) NOT NULL,
  `CompanyID` INTEGER NOT NULL,
  `InsertionDate` DATETIME NOT NULL DEFAULT NOW(),
  `StartDate` DATETIME NOT NULL DEFAULT NOW(),
  `EndDate` DATETIME,
  CONSTRAINT `FK_Discounts`
    FOREIGN KEY (`CompanyID`) REFERENCES Companies (`CompanyID`),
  CHECK (DiscountValue <= 1 AND DiscountValue > 0)
);

CREATE OR REPLACE TABLE Discounts_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `DiscountID` INTEGER NOT NULL,
  `DiscountValue` FLOAT(3, 2) NOT NULL,
  `CompanyID` INTEGER NOT NULL,
  `InsertionDate` DATETIME NOT NULL DEFAULT NOW(),
  `StartDate` DATETIME NOT NULL DEFAULT NOW(),
  `EndDate` DATETIME
);

CREATE OR REPLACE TABLE Orders(
  `OrderID` INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `ClientID` INTEGER NOT NULL,
  `LessonID` INTEGER,
  `CompanyID` INTEGER,
  `CourseID` INTEGER,
  `StartDate` DATETIME NOT NULL DEFAULT NOW(),
  `EndDate` DATETIME,
  `Price` FLOAT(6, 2) NOT NULL,
  `DiscountID` INTEGER,
  `ClientDiscount` FLOAT(3,2) DEFAULT 0.00,
  CONSTRAINT `FK_Orders`
    FOREIGN KEY (`LessonID`) REFERENCES Lessons (`LessonID`),
    FOREIGN KEY (`ClientID`) REFERENCES Clients (`ClientID`),
    FOREIGN KEY (`CompanyID`) REFERENCES Companies (`CompanyID`),
    FOREIGN KEY (`DiscountID`) REFERENCES Discounts (`DiscountID`),
  CHECK ((`LessonID` IS NOT NULL AND `CompanyID` IS NULL) OR (`LessonID` IS NULL AND `CompanyID` IS NOT NULL))
);

CREATE OR REPLACE TABLE Orders_deleted(
  `UserWhoDelete` VARCHAR(20) NOT NULL,
  `DeleteDate` DATETIME NOT NULL DEFAULT NOW(),
  `OrderID` INTEGER NOT NULL,
  `ClientID` INTEGER NOT NULL,
  `LessonID` INTEGER,
  `CompanyID` INTEGER,
  `CourseID` INTEGER,
  `StartDate` DATETIME NOT NULL DEFAULT NOW(),
  `EndDate` DATETIME,
  `Price` FLOAT(6, 2) NOT NULL,
  `DiscountID` INTEGER,
  `ClientDiscount` FLOAT(3,2) DEFAULT 0.00
);

DELIMITER //

      CREATE OR REPLACE FUNCTION calculateClientDiscount(currClientID INTEGER)
      RETURNS FLOAT(3,2)
      BEGIN

        DECLARE regDate DATETIME;
        DECLARE yearDiff INTEGER;
        SELECT `RegisterDate` FROM Clients
          WHERE `ClientID` = currClientID
          INTO regDate;
        SELECT TIMESTAMPDIFF(YEAR, regDate, NOW())
          INTO yearDiff;

        IF yearDiff < 1 THEN
          RETURN 0.00;
        ELSEIF yearDiff  = 1 THEN
          RETURN 0.05;
        ELSEIF yearDiff = 2 THEN
          RETURN 0.08;
        ELSEIF yearDiff = 3 THEN
          RETURN 0.11;
        ELSE RETURN 0.15;
        END IF;

      END;

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE RegisterUser(type VARCHAR(6), userLogin VARCHAR(30), userPassword VARCHAR(30),
        fName VARCHAR(20), lName VARCHAR(30), phone VARCHAR(15), email VARCHAR(30), secondPhone VARCHAR(15))
      BEGIN

        IF type = 'Client' THEN

          INSERT INTO Users(`UserType`, `Login`, `Password`, `PhoneNumber`, `E-mail`, `ReservePhoneNumber`)
            VALUES(type, userLogin, userPassword, phone, email, secondPhone);

          INSERT INTO Clients(`LastName`, `FirstName`, `UserID`)
            VALUES(lName, fName, LAST_INSERT_ID());

        ELSEIF type = 'Tutor' THEN

          INSERT INTO Users(`UserType`, `Login`, `Password`, `PhoneNumber`, `E-mail`, `ReservePhoneNumber`)
           VALUES(type, userLogin, userPassword, phone, email, secondPhone);

          INSERT INTO Tutors(`LastName`, `FirstName`, `UserID`)
           VALUES(lName, fName, LAST_INSERT_ID());

        ELSE SELECT 'Incorrect user type!';

        END IF;

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE RegisterCompany(compName VARCHAR(40), phone VARCHAR(15), email VARCHAR(30),
        secondPhone VARCHAR(15), courseName VARCHAR(30))
      BEGIN

        DECLARE currCourseID INTEGER;
        SELECT CourseID FROM Courses WHERE Courses.CourseName = courseName INTO currCourseID;

        INSERT INTO Companies(`CompanyName`, `PhoneNumber`, `E-mail`, `ReservePhoneNumber`, `CourseID`)
          VALUES(compName, phone, email, secondPhone, currCourseID);

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE RegisterLesson(tutorName VARCHAR(50), subjName VARCHAR(20))
      BEGIN

        DECLARE currTutorID INTEGER;
        DECLARE currSubjID INTEGER;

        SELECT `TutorID` FROM Tutors WHERE CONCAT(`FirstName`, ' ', `LastName`) = tutorName INTO currTutorID;
        SELECT `SubjectID` FROM Subjects WHERE `SubjectName` = subjName INTO currSubjID;

        INSERT INTO Lessons(`TutorID`, `SubjectID`)
          VALUES(currTutorID, currSubjID);

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE RegisterDiscount(discValue FLOAT(3,2), compName VARCHAR(40), start DATETIME,
                                                   end DATETIME)
        BEGIN

          DECLARE currCompanyID INTEGER;

          SELECT `CompanyID` FROM Companies WHERE `CompanyName` = compName INTO currCompanyID;

          INSERT INTO Discounts(`DiscountValue`, `CompanyID`, `StartDate`, `EndDate`)
            VALUES(discValue, currCompanyID, start, end);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE RegisterOrder(clientName VARCHAR(50), tutorName VARCHAR(50), subjName VARCHAR(20),
                                                compName VARCHAR(40), crsName VARCHAR(30), orderStart DATETIME,
                                                orderEnd DATETIME)
      `wholeProc`:
      BEGIN

        DECLARE currClientID INTEGER;
        DECLARE currLessonID INTEGER;
        DECLARE currTutorID INTEGER;
        DECLARE currSubjID INTEGER;
        DECLARE currCompanyID INTEGER;
        DECLARE currCourseID INTEGER;
        DECLARE currClientDiscount FLOAT(3,2) DEFAULT 0;
        DECLARE currDiscountID INTEGER;
        DECLARE currDiscountValue FLOAT(3,2) DEFAULT 0;
        DECLARE currPrice FLOAT(6,2);
        DECLARE finalPrice FLOAT(6,2);

        SELECT `TutorID` FROM Tutors
          WHERE CONCAT(Tutors.`FirstName`, ' ', Tutors.`LastName`) = tutorName
          INTO currTutorID;

        SELECT `SubjectID` FROM Subjects WHERE Subjects.`SubjectName` = subjName
          INTO currSubjID;

        SELECT `LessonID` FROM Lessons WHERE Lessons.TutorID = currTutorID AND Lessons.SubjectID = currSubjID
          INTO currLessonID;

        IF currLessonID IS NULL AND tutorName IS NOT NULL AND subjName IS NOT NULL THEN
          SELECT 'This tutor doesn\'t support given subject.';
          LEAVE `wholeProc`;
        END IF;

        SELECT `ClientID` FROM Clients
          WHERE CONCAT(Clients.`FirstName`, ' ', Clients.`LastName`) = clientName
          INTO currClientID;

        SELECT `CompanyID` FROM Companies WHERE Companies.`CompanyName` = compName
          INTO currCompanyID;

        SELECT `CourseID` FROM Courses WHERE Courses.`CourseName` = crsName
          INTO currCourseID;

        SELECT calculateClientDiscount(currClientID)
          INTO currClientDiscount;

        SELECT `DiscountValue`, `DiscountID` FROM Discounts
          WHERE NOW() BETWEEN Discounts.`StartDate` AND Discounts.`EndDate`
            AND Discounts.`CompanyID` = currCompanyID
          ORDER BY Discounts.`InsertionDate`
          LIMIT 1
          INTO currDiscountValue, currDiscountID;

        IF currLessonID IS NOT NULL THEN
          SELECT `Price` FROM Subjects WHERE Subjects.`SubjectName` = subjName
            INTO currPrice;
        ELSE
          SELECT `Price` FROM Courses WHERE Courses.`CourseName` = crsName
            INTO currPrice;
        END IF;

        SET finalPrice = currPrice * (1 - currClientDiscount) * (1 - currDiscountValue);

        INSERT INTO Orders(`ClientID`, `LessonID`, `CompanyID`, `CourseID`, `StartDate`, `EndDate`, `Price`,
                           `DiscountID`, `ClientDiscount`)
        VALUES(currClientID, currLessonID, currCompanyID, currCourseID, orderStart, orderEnd, finalPrice,
               currDiscountID, currClientDiscount);

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE IncomePerPeriod(startDate DATETIME, endDate DATETIME)
      BEGIN

        IF startDate IS NULL THEN
          SET startDate = NOW();
        ELSEIF endDate IS NULL THEN
          SET endDate = NOW();
        END IF;

        SELECT * FROM Orders WHERE Orders.StartDate BETWEEN startDate AND endDate;

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE IncomePerClient(clientName VARCHAR(50))
      BEGIN

        DECLARE currClientID INTEGER;

        SELECT `ClientID` FROM Clients WHERE CONCAT(`FirstName`, ' ', `LastName`) = clientName INTO currClientID;

        SELECT * FROM Orders JOIN Clients C ON Orders.ClientID = C.ClientID
          WHERE C.ClientID = currClientID;

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE IncomePerTutor(tutorName VARCHAR(50))
      BEGIN

        DECLARE currTutorID INTEGER;

        SELECT `TutorID` FROM Tutors WHERE CONCAT(`FirstName`, ' ', `LastName`) = tutorName INTO currTutorID;

        SELECT * FROM Orders
          JOIN Lessons L on Orders.LessonID = L.LessonID
          WHERE L.`TutorID` = currTutorID;

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE IncomePerCompany(compName VARCHAR(50))
      BEGIN

        DECLARE currCompanyID INTEGER;

        SELECT `CompanyID` FROM Companies WHERE `CompanyName` = compName INTO currCompanyID;

        SELECT * FROM Orders JOIN Companies C ON Orders.CompanyID = C.CompanyID
          WHERE C.CompanyID = currCompanyID;

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE PROCEDURE getOrderStatus(currOrderID INTEGER)
      BEGIN

        DECLARE start DATETIME;
        DECLARE end DATETIME;

        SELECT `StartDate`, `EndDate` FROM Orders WHERE Orders.`OrderID` = currOrderID
          INTO start, end;

        IF NOW() < start THEN
          SELECT 'Ordered';
        ELSEIF NOW() > start AND NOW() > end THEN
          SELECT 'Active';
        ELSE
          SELECT 'Finished';
        END IF;

      END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER checkRating
        BEFORE INSERT ON Rating
        FOR EACH ROW
        BEGIN

        IF (NOT EXISTS(
            SELECT * FROM Orders
              JOIN Lessons L on Orders.LessonID = L.LessonID
              WHERE Orders.ClientID = NEW.ClientID AND L.TutorID = NEW.TutorID
            ))
          THEN
            SIGNAL SQLSTATE '70002'
            SET MESSAGE_TEXT = 'This client had no lessons with this teacher';
        END IF;

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER calculateRating
        AFTER INSERT ON Rating
        FOR EACH ROW
        BEGIN

        DECLARE sum INTEGER;
        DECLARE amount INTEGER;

        SELECT SUM(`Rating`), COUNT(*) FROM Rating WHERE Rating.`TutorID` = NEW.`TutorID`
          INTO sum, amount;

        UPDATE Tutors SET `Rating` = sum / amount
            WHERE `TutorID` = NEW.`TutorID`;

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER subjects_deleteLog
        AFTER DELETE ON Subjects
        FOR EACH ROW
        BEGIN

        INSERT INTO Subjects_deleted(`UserWhoDelete`, `DeleteDate`, `SubjectID`, `SubjectName`, `Price`)
        VALUES(USER(), NOW(), OLD.`SubjectID`, OLD.`SubjectName`, OLD.`Price`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER discounts_deleteLog
        AFTER DELETE ON Discounts
        FOR EACH ROW
        BEGIN

        INSERT INTO Discounts_deleted(`UserWhoDelete`, `DeleteDate`, `DiscountID`, `DiscountValue`, `CompanyID`,
                                      `InsertionDate`, `StartDate`, `EndDate`)
        VALUES(USER(), NOW(), OLD.`DiscountID`, OLD.`DiscountValue`, OLD.`CompanyID`, OLD.`InsertionDate`, OLD.`StartDate`,
               OLD.`EndDate`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER users_deleteLog
        AFTER DELETE ON Users
        FOR EACH ROW
        BEGIN

        INSERT INTO Users_deleted(`UserWhoDelete`, `DeleteDate`, `UserID`, `UserType`, `Login`, `Password`,
                                  `PhoneNumber`,`E-mail`, `ReservePhoneNumber`)
        VALUES(USER(), NOW(), OLD.`UserID`, OLD.`UserType`, OLD.`Login`, OLD.`Password`, OLD.`PhoneNumber`,
               OLD.`E-mail`, OLD.`ReservePhoneNumber`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER courses_deleteLog
        AFTER DELETE ON Courses
        FOR EACH ROW
        BEGIN

        INSERT INTO Courses_deleted(`UserWhoDelete`, `DeleteDate`, `CourseID`, `CourseName`, `Price`)
        VALUES(USER(), NOW(), OLD.`CourseID`, OLD.`CourseName`, OLD.`Price`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER clients_deleteLog
        AFTER DELETE ON Clients
        FOR EACH ROW
        BEGIN

        INSERT INTO Clients_deleted(`UserWhoDelete`, `DeleteDate`, `ClientID`, `LastName`, `FirstName`, `RegisterDate`,
                                    `UserID`)
        VALUES(USER(), NOW(), OLD.`ClientID`, OLD.`LastName`, OLD.`FirstName`, OLD.`RegisterDate`, OLD.`UserID`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER tutors_deleteLog
        AFTER DELETE ON Tutors
        FOR EACH ROW
        BEGIN

        INSERT INTO Tutors_deleted(`UserWhoDelete`, `DeleteDate`, `TutorID`, `FirstName`, `LastName`, `Rating`,
                                   `UserID`)
        VALUES(USER(), NOW(), OLD.`TutorID`, OLD.`FirstName`, OLD.`LastName`, OLD.`Rating`, OLD.`UserID`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER rating_deleteLog
        AFTER DELETE ON Rating
        FOR EACH ROW
        BEGIN

        INSERT INTO Rating_deleted(`UserWhoDelete`, `DeleteDate`, `RecordID`, `ClientID`, `TutorID`, `Rating`)
        VALUES(USER(), NOW(), OLD.`RecordID`, OLD.`ClientID`, OLD.`TutorID`, OLD.`Rating`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER lessons_deleteLog
        AFTER DELETE ON Lessons
        FOR EACH ROW
        BEGIN

        INSERT INTO Lessons_deleted(`UserWhoDelete`, `DeleteDate`, `LessonID`, `TutorID`, `SubjectID`)
        VALUES(USER(), NOW(), OLD.`LessonID`, OLD.`TutorID`, OLD.`SubjectID`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER companies_deleteLog
        AFTER DELETE ON Companies
        FOR EACH ROW
        BEGIN

        INSERT INTO Companies_deleted(`UserWhoDelete`, `DeleteDate`, `CompanyID`, `CompanyName`, `PhoneNumber`,
                                      `E-mail`, `ReservePhoneNumber`, `CourseID`)
        VALUES(USER(), NOW(), OLD.`CompanyID`, OLD.`CompanyName`, OLD.`PhoneNumber`, OLD.`E-mail`,
               OLD.`ReservePhoneNumber`, OLD.`CourseID`);

        END; //

DELIMITER ;

DELIMITER //

      CREATE OR REPLACE TRIGGER orders_deleteLog
        AFTER DELETE ON Orders
        FOR EACH ROW
        BEGIN

        INSERT INTO Orders_deleted(`UserWhoDelete`, `DeleteDate`, `OrderID`, `ClientID`, `LessonID`, `CompanyID`,
                                      `CourseID`, `StartDate`, `EndDate`, `Price`, `DiscountID`, `ClientDiscount`)
        VALUES(USER(), NOW(), OLD.`OrderID`, OLD.`ClientID`, OLD.`LessonID`, OLD.`CompanyID`, OLD.`CourseID`,
               OLD.`StartDate`, OLD.`EndDate`, OLD.`Price`, OLD.`DiscountID`, OLD.`ClientDiscount`);

        END; //

DELIMITER ;

CREATE ROLE admin;
GRANT ALL ON LazyStudent.* TO admin;

CREATE ROLE employee;
REVOKE ALL ON LazyStudent.* FROM employee;
GRANT SELECT ON LazyStudent.Clients TO employee;
GRANT SELECT ON LazyStudent.Companies TO employee;
GRANT SELECT ON LazyStudent.Courses TO employee;
GRANT SELECT ON LazyStudent.Discounts TO employee;
GRANT SELECT ON LazyStudent.Lessons TO employee;
GRANT SELECT ON LazyStudent.Orders TO employee;
GRANT SELECT ON LazyStudent.Rating TO employee;
GRANT SELECT ON LazyStudent.Subjects TO employee;
GRANT SELECT ON LazyStudent.Tutors TO employee;
GRANT SELECT ON LazyStudent.Users TO employee;

GRANT EXECUTE ON PROCEDURE LazyStudent.getOrderStatus TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.IncomePerClient TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.IncomePerCompany TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.IncomePerPeriod TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.IncomePerTutor TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterCompany TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterDiscount TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterLesson TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterOrder TO employee;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterUser TO employee;

CREATE ROLE director;
REVOKE ALL ON LazyStudent.* FROM director;
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, ALTER ON LazyStudent.* TO director;

GRANT EXECUTE ON PROCEDURE LazyStudent.getOrderStatus TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.IncomePerClient TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.IncomePerCompany TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.IncomePerPeriod TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.IncomePerTutor TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterCompany TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterDiscount TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterLesson TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterOrder TO director;
GRANT EXECUTE ON PROCEDURE LazyStudent.RegisterUser TO director;
GRANT EXECUTE ON FUNCTION LazyStudent.getOrderStatus TO director;

CALL RegisterUser('Client', 'login1', '1234', 'Cirilla', 'Fiannon', '+380501234567', 'ciri@email.com', NULL);
CALL RegisterUser('Client', 'login2', '1234', 'Yennefer', 'Of Vengerberg', '+380504172648', 'yenn@email.com', '+380635729538');
CALL RegisterUser('Client', 'login3', '1234', 'Geralt', 'Of Rivia', '+380508572958', 'witcher@email.com', NULL);
CALL RegisterUser('Client', 'login4', '1234', 'Triss', 'Merigold', '+380501234567', 'triss@email.com', '+380631273490');
CALL RegisterUser('Tutor', 'login5', '1234', 'Gaunter', 'O\'Dimm', '+380504820538', 'gaunter@email.com', NULL);
CALL RegisterUser('Tutor', 'login6', '1234', 'Emhyr', 'van Emreis', '+380505829548', 'blackKing@email.com', NULL);

INSERT INTO Courses(`CourseName`, `Price`)
  VALUES ('English', 100),
         ('Spanish', 150),
         ('Programming', 300),
         ('Killing monsters', 200);

INSERT INTO Subjects(`SubjectName`, `Price`)
  VALUES ('Math', 175),
         ('Geography', 200),
         ('Biology', 250),
         ('Literature', 200);

CALL RegisterCompany('Z-digital', '+380504720152', 'Zmail@zdigital.com', NULL, 'Programming');
CALL RegisterCompany('Witcherzz', '+380995482270', 'mercenaries@monsters.com', '+380635673859', 'Killing monsters');
CALL RegisterCompany('Corrida de Toros', '+380635163232', 'toros@spain.com', NULL, 'Spanish');

CALL RegisterLesson('Gaunter O\'Dimm', 'Geography');
CALL RegisterLesson('Emhyr van Emreis', 'Literature');

CALL RegisterDiscount(0.25, 'Witcherzz', '2019-03-11 23:59:00', '2020-04-11 23:59:00');
CALL RegisterDiscount(0.15, 'Z-digital', '2019-06-01 00:00:00', '2019-08-31 23:59:00');

CALL RegisterOrder('Geralt Of Rivia', 'Emhyr van Emreis', 'Literature', NULL, NULL, '2019-3-11 00:00:00',
                   '2019-11-11 23:59:00');
CALL RegisterOrder('Triss Merigold', NULL, NULL, 'Witcherzz', 'Killing monsters', '2019-11-11 23:59:00',
                   '2019-12-11 23:59:00');

select * from Orders;

CALL IncomePerPeriod('2018-3-11 00:00:00', '2020-11-11 23:59:00');
CALL IncomePerClient('Triss Merigold');
CALL IncomePerTutor('Emhyr van Emreis');
CALL IncomePerCompany('Witcherzz');
