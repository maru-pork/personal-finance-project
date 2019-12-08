-- DELIMITER $$
CREATE TRIGGER AfterLiabInsert
    AFTER INSERT ON Liabilities
    FOR EACH ROW
BEGIN
CALL UpdateLiabilityAmount(NEW.bsId);
END -- $$
-- DELIMITER ;