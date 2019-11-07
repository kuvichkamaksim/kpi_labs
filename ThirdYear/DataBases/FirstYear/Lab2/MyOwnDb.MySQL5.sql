# ---------------------------------------------------------------------- #
# Target DBMS:           MySQL 5                                         #
# Project name:          My Own DB                                       #
# Author:                Kuvichka Maksim                                 #
# Created on:            2019-22-02 19:00                                #
# ---------------------------------------------------------------------- #
DROP DATABASE IF EXISTS mydb;

CREATE DATABASE IF NOT EXISTS mydb;

USE mydb;

# ---------------------------------------------------------------------- #
# Tables                                                                 #
# ---------------------------------------------------------------------- #
# ---------------------------------------------------------------------- #
# Add table "Users"                                                      #
# ---------------------------------------------------------------------- #

CREATE TABLE Users (
    `UserID` INTEGER NOT NULL AUTO_INCREMENT,
    `LastName` VARCHAR(20) NOT NULL,
    `FirstName` VARCHAR(10) NOT NULL,
    CONSTRAINT `PK_Users` PRIMARY KEY (`UserID`)
);

# ---------------------------------------------------------------------- #
# Add info into "Users"                                                  #
# ---------------------------------------------------------------------- #

TRUNCATE TABLE Users;
INSERT INTO Users VALUES(null, 'Kuvichka', 'Maksim');

