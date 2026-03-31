DROP DATABASE IF EXISTS legodb;
CREATE DATABASE legodb;
USE legodb;

-- Item
CREATE TABLE Item
	(ItemID VARCHAR(8),
	 ItemName VARCHAR(255) NOT NULL,
	 YearReleased INT,
     YearEnd INT,
     ItemWeight DECIMAL(10,2),
     isLicensed BOOLEAN NOT NULL DEFAULT 0,
	 PRIMARY KEY(ItemID)
	);

-- Color
CREATE TABLE Color (
    Name VARCHAR(100),
    PRIMARY KEY (Name)
);

-- Set
CREATE TABLE `Set` (
    ItemID VARCHAR(8),
    PRIMARY KEY (ItemID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
        ON DELETE CASCADE
);

-- Minifigs
CREATE TABLE Minifig (
    ItemID VARCHAR(8),
    PRIMARY KEY (ItemID),
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
        ON DELETE CASCADE
);

-- Part
CREATE TABLE Part (
    ItemID VARCHAR(8),
    ColorName VARCHAR(100),
    isModified BOOLEAN,
    isDecorated BOOLEAN,
    
    PRIMARY KEY (ItemID),
    
    FOREIGN KEY (ItemID) REFERENCES Item(ItemID)
        ON DELETE CASCADE,
    FOREIGN KEY (ColorName) REFERENCES Color(Name)
);

-- Set_Parts
CREATE TABLE Set_Parts (
    SetItemID VARCHAR(8),
    PartItemID VARCHAR(8),
    Quantity INT NOT NULL DEFAULT 1,

    PRIMARY KEY (SetItemID, PartItemID),
    
    FOREIGN KEY (SetItemID) REFERENCES `Set`(ItemID)
        ON DELETE CASCADE,
    FOREIGN KEY (PartItemID) REFERENCES Part(ItemID)
        ON DELETE CASCADE
);
-- Minifigure_Parts
CREATE TABLE Minifig_Parts (
    MinifigItemID VARCHAR(8),
    PartItemID VARCHAR(8),
    
    PRIMARY KEY (MinifigItemID, PartItemID),
    
    FOREIGN KEY (MinifigItemID) REFERENCES Minifig(ItemID)
        ON DELETE CASCADE,
    FOREIGN KEY (PartItemID) REFERENCES Part(ItemID)
        ON DELETE CASCADE
);

-- Set_Minifigure
CREATE TABLE Set_Minifigs (
    SetItemID VARCHAR(8),
    MinifigItemID VARCHAR(8),
    Quantity INT NOT NULL DEFAULT 1,
    
    PRIMARY KEY (SetItemID, MinifigItemID),
    
    FOREIGN KEY (SetItemID) REFERENCES `Set`(ItemID)
        ON DELETE CASCADE,
    FOREIGN KEY (MinifigItemID) REFERENCES Minifig(ItemID)
        ON DELETE CASCADE
);