-- DELIMITER $$
CREATE TRIGGER AfterAssetInsert
    AFTER INSERT ON Assets
    FOR EACH ROW
BEGIN
CALL UpdateAssetAmount(NEW.bsId);
CALL UpdateAssetGroupAmount(NEW.assetGroupId);
END -- $$
-- DELIMITER ;