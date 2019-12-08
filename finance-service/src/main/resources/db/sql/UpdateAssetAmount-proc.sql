-- DELIMITER $$
CREATE PROCEDURE UpdateAssetAmount (bsIdParam INT)
BEGIN
	UPDATE BalanceSheet 
	SET 
		assetAmt = (SELECT SUM(currentAmt) FROM Assets 
							WHERE bsId=bsIdParam and isActive=true and isPaper=false
                            GROUP BY bsId),
		netWorth = (assetAmt-liabAmt)
	WHERE bsId = bsIdParam;
END -- $$
-- DELIMITER ;