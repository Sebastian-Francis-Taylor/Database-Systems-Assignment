USE legodb;

-- Had Major erros with mariadb seeing clones. Only fix i know is to drop them before creating them.
DROP FUNCTION IF EXISTS PartCount;
DROP PROCEDURE IF EXISTS AddMinifigToSet;
DROP PROCEDURE IF EXISTS RemoveMinifigFromSet;
DROP TRIGGER IF EXISTS CheckYears;
DROP PROCEDURE IF EXISTS MoveMinifig;
DROP FUNCTION IF EXISTS TotalSetsMinifigIsIn;



DELIMITER //
CREATE FUNCTION PartCount(vSetItemID VARCHAR(8)) RETURNS INT
BEGIN
    DECLARE vCount INT;
    SELECT SUM(Quantity) INTO vCount FROM Set_Parts WHERE SetItemID = vSetItemID;
    RETURN vCount;
END; //
DELIMITER ;

DELIMITER //
CREATE FUNCTION TotalSetsMinifigIsIn(vMinifigItemID VARCHAR(8)) RETURNS INT
BEGIN
    DECLARE vCount INT;
    SELECT COUNT(*) INTO vCount FROM Set_Minifigs WHERE MinifigItemID = vMinifigItemID;
    RETURN vCount;
END; //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE AddMinifigToSet(vSetItemID VARCHAR(8), vMinifigItemID VARCHAR(8), vQuantity INT)
BEGIN
    IF EXISTS (SELECT 1 FROM Set_Minifigs WHERE SetItemID = vSetItemID AND MinifigItemID = vMinifigItemID) THEN
        UPDATE Set_Minifigs
        SET Quantity = Quantity + vQuantity
        WHERE SetItemID = vSetItemID AND MinifigItemID = vMinifigItemID;
    ELSE
        INSERT INTO Set_Minifigs (SetItemID, MinifigItemID, Quantity)
        VALUES (vSetItemID, vMinifigItemID, vQuantity);
    END IF;
END; //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE RemoveMinifigFromSet(vSetItemID VARCHAR(8), vMinifigItemID VARCHAR(8), vAmount INT)
BEGIN
    UPDATE Set_Minifigs
    SET Quantity = Quantity - vAmount WHERE SetItemID = vSetItemID AND MinifigItemID = vMinifigItemID;
    DELETE FROM Set_Minifigs WHERE SetItemID = vSetItemID AND Quantity <= 0;    
    
END; //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE MoveMinifig(vFromSetID VARCHAR(8), vToSetID VARCHAR(8), vMinifigItemID VARCHAR(8), vQuantity INT)
BEGIN 
    IF EXISTS (SELECT 1 FROM Set_Minifigs WHERE SetItemID = vFromSetID AND MinifigItemID = vMinifigItemID) Then
        CALL RemoveMinifigFromSet(vFromSetID, vMinifigItemID, vQuantity);
        CALL AddMinifigToSet(vToSetID, vMinifigItemID, vQuantity);
    Else 
        SIGNAL SQLSTATE '45000' 
        SET Message_Text = 'Minifig does not exist';
    END IF;
END; //
DELIMITER ;



DELIMITER //
CREATE TRIGGER CheckYears
BEFORE INSERT ON Item FOR EACH ROW
BEGIN 
    IF NEW.YearEnd IS NOT NULL AND NEW.YearReleased IS NOT NULL AND NEW.YearEnd < NEW.YearReleased THEN 
        SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'YearEnd cannot be before YearReleased';
    END IF;
END; //
DELIMITER ;
