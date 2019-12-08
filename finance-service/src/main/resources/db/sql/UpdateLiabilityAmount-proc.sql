-- DELIMITER $$
CREATE PROCEDURE UpdateLiabilityAmount (bsIdParam INT)
BEGIN
	UPDATE BalanceSheet 
	SET 
		liabAmt = (SELECT SUM(currentAmt) FROM Liabilities  
						WHERE bsId=bsIdParam and isActive=true and isPaper=false
						GROUP BY bsId),
		netWorth = (assetAmt-liabAmt)
	WHERE bsId = bsIdParam;
END -- $$
-- DELIMITER ;