-- =============================================================
-- LEGO Database Schema
-- MariaDB / MySQL
-- =============================================================

-- =====================
-- Base Tables
-- =====================

CREATE TABLE Person (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Salary DECIMAL(10, 2),
    WorkLocation VARCHAR(255),
    Role VARCHAR(255)
);

CREATE TABLE Minifigure (
   ItemNo INT PRIMARY KEY,
   Name VARCHAR(255)
);

CREATE TABLE Minifigure_Designer (
   MinifigureItemNo INT,
   DesignerID INT,
   PRIMARY KEY (MinifigureItemNo, DesignerID),
   FOREIGN KEY (MinifigureItemNo) REFERENCES Minifigure(ItemNo),
   FOREIGN KEY (DesignerID) REFERENCES Person(EmployeeID)
);

CREATE TABLE Set_Minifigure (
   SetNumber INT,
   MinifigureItemNo INT,
   Quantity INT DEFAULT 1,
   PRIMARY KEY (SetNumber, MinifigureItemNo),
   FOREIGN KEY (SetNumber) REFERENCES `Set`(SetNo),
   FOREIGN KEY (MinifigureItemNo) REFERENCES Minifigure(ItemNo)
);

