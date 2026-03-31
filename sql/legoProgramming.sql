USE legodb;




DELIMITER //
CREATE FUNCTION PartCount(vsetItemID VARCHAR(8)) RETURNS INT
BEGIN
    DECLARE vcount INT;
    SELECT SUM(Quantity) INTO vCount FROM Set_Parts WHERE SetItemID = vSetItemID;
    RETURN vCount;
END; //
DELIMITER;



DELIMITER //
CREATE PROCEDURE  AddMinifigToSet(vSetItemID VARCHAR(8), vMinifigItemID VARCHAR(8), vQuantity INT)
BEGIN
    INSERT INTO Set_Minifigs (setItemID, MinifigItemID, Quantity)
    VALUES (vSetItemID, vMinifigItemID, vQuantity);
END; //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE RemoveMinifigFromSet(vSetItemID VARCHAR(8), vMinifigItemID VARCHAR(8))
BEGIN
    DELETE FROM Set_Minifigs WHERE SetItemID = vSetItemID AND MinifigItemID = vMinifigItemID;
END; //
DELIMITER ;



DELIMITER //
CREATE TRIGGER CheckYears
BEFORE  INSERT ON Item FOR EACH ROW
BEGIN 
    IF NEW.YearEnd IS NOT NULL AND NEW.YearReleased IS NOT NULL AND NEW.YearEnd < NEW.YearReleased THEN 
        SIGNAL SQLSTATE'45000' 
    SET MESSAGE_TEXT 'YearEnd cannot be before YearReleased'
    END IF;
END; //
DELIMITER ;







-- Example
--CALL AddMinifigToSet('75194', 'MF0010', 2);

-- Example
--CALL RemoveMinifigFromSet('75192', 'MF0001');



-- Example: Valid
--INSERT INTO Item VALUES ('75193', 'Valid Item', 2015, 2020, 1.5, 0);

-- Example: Invalid
--INSERT INTO Item VALUES ('75194', 'Invalid Item', 2020, 2010, 1.5, 0);