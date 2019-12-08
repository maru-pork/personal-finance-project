-- DELIMITER $$
CREATE TRIGGER AfterLiabUpdate
    AFTER UPDATE ON Liabilities
    FOR EACH ROW
BEGIN
CALL UpdateLiabilityAmount(NEW.bsId);
END -- $$
-- DELIMITER ;