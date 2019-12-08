-- DELIMITER $$
CREATE TRIGGER AfterAssetUpdate
    AFTER UPDATE ON Assets
    FOR EACH ROW
BEGIN
CALL UpdateAssetAmount(NEW.bsId);
CALL UpdateAssetGroupAmount(NEW.assetGroupId);
END -- $$
-- DELIMITER ;