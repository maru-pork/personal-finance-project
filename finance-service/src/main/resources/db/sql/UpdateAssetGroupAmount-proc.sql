-- DELIMITER $$
CREATE PROCEDURE UpdateAssetGroupAmount (assetGroupIdParam INT)
BEGIN
	UPDATE AssetGroups 
	SET 
		assetSumAmt = (SELECT SUM(currentAmt) FROM Assets 
						WHERE assetGroupId=assetGroupIdParam and isActive=true and isPaper=false
						GROUP BY assetGroupId)
	WHERE assetGroupId = assetGroupIdParam;
END -- $$
-- DELIMITER ;