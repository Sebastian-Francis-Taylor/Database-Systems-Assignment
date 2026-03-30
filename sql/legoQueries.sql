USE legodb;

-- Which sets have the most minifigures?
-- Retrieves each set's name along with the total number of minifigures
-- included, ordered from most to fewest.
SELECT i.ItemName AS SetName, SUM(sm.Quantity) AS TotalMinifigs
FROM `Set` s
JOIN Item i ON s.ItemID = i.ItemID
JOIN Set_Minifigs sm ON s.ItemID = sm.SetItemID
GROUP BY s.ItemID, i.ItemName
ORDER BY TotalMinifigs DESC;

-- List all parts used in sets and all parts used in minifigures.
-- Uses UNION to combine parts from Set_Parts and Minifig_Parts into a
-- single result, labeling each row's source. Uses IN to filter parts
-- belonging to each category.
SELECT i.ItemName AS PartName, p.ColorName, 'Set' AS UsedIn
FROM Part p
JOIN Item i ON p.ItemID = i.ItemID
WHERE p.ItemID IN (SELECT PartItemID FROM Set_Parts)
UNION
SELECT i.ItemName AS PartName, p.ColorName, 'Minifig' AS UsedIn
FROM Part p
JOIN Item i ON p.ItemID = i.ItemID
WHERE p.ItemID IN (SELECT PartItemID FROM Minifig_Parts);

-- Which licensed sets include more than 2 minifigures?
-- Joins sets with their minifigure assignments, filters to only licensed
-- sets, and uses HAVING to keep only those whose total minifigure count
-- exceeds 2.
SELECT i.ItemName AS SetName, SUM(sm.Quantity) AS TotalMinifigs
FROM `Set` s
JOIN Item i ON s.ItemID = i.ItemID
JOIN Set_Minifigs sm ON s.ItemID = sm.SetItemID
WHERE i.isLicensed = 1
GROUP BY s.ItemID, i.ItemName
HAVING SUM(sm.Quantity) > 2;
