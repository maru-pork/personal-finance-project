-- TABLES --
DROP TABLE IF EXISTS Goals
/;
DROP TABLE IF EXISTS Liabilities
/;
DROP TABLE IF EXISTS Assets
/;
DROP TABLE IF EXISTS AssetGroups
/;
DROP TABLE IF EXISTS  BalanceSheet
/;

CREATE TABLE BalanceSheet (
	bsId INT NOT NULL AUTO_INCREMENT,
	asOfDate DATE NOT NULL,
	isSubmitted BOOL DEFAULT 0,
	assetAmt DOUBLE(11, 2) NOT NULL DEFAULT 0.00,
	liabAmt DOUBLE(11, 2) NOT NULL DEFAULT 0.00,
	netWorth  DOUBLE(11, 2) NOT NULL DEFAULT 0.00,
	PRIMARY KEY(bsId),
	CONSTRAINT UniqueAsOfDate UNIQUE (asOfDate)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1
/;

CREATE TABLE AssetGroups (
	assetGroupId  INT NOT NULL AUTO_INCREMENT,
	assetGroupCode VARCHAR(64) NOT NULL,
	description VARCHAR(255),
	currentAmt  DOUBLE(10, 2) NOT NULL,
	assetSumAmt DOUBLE(10, 2) NOT NULL,
	PRIMARY KEY(assetGroupId),
	CONSTRAINT UniqueAssetGroupCode UNIQUE (assetGroupCode)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1
/;

CREATE TABLE Assets (
	assetId INT NOT NULL AUTO_INCREMENT,
	assetGroupId INT DEFAULT NULL,
	bsId  INT NOT NULL,
	assetType VARCHAR(32),
	assetCode VARCHAR(64) NOT NULL,
	description VARCHAR(255),
	currentAmt DOUBLE(11, 2) NOT NULL,
	isActive BOOL NOT NULL DEFAULT TRUE,
	isPaper BOOL NOT NULL DEFAULT FALSE,
	PRIMARY KEY(assetId),
	CONSTRAINT AssetGroupFK FOREIGN KEY (assetGroupId) REFERENCES AssetGroups(assetGroupId) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT BsFK1 FOREIGN KEY (bsId) REFERENCES BalanceSheet(bsId) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT UniqueAssetCode UNIQUE (assetCode)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1
/;

CREATE TABLE Liabilities (
	liabId INT NOT NULL AUTO_INCREMENT,
	bsId  INT NOT NULL,
	liabType VARCHAR(32),
	liabCode VARCHAR(64) NOT NULL,
	description VARCHAR(255),
    liabAmt DOUBLE(11, 2) NOT NULL,
	currentAmt DOUBLE(11, 2) NOT NULL,
	isActive BOOL NOT NULL DEFAULT TRUE,
	isPaper BOOL NOT NULL DEFAULT FALSE,
	PRIMARY KEY(liabId),
	CONSTRAINT BsFK2 FOREIGN KEY (bsId) REFERENCES BalanceSheet(bsId) ON DELETE NO ACTION ON UPDATE NO ACTION,
	CONSTRAINT UniqueLiabCode UNIQUE (liabCode)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1
/;

CREATE TABLE Goals (
	goalId INT NOT NULL AUTO_INCREMENT,
	assetId INT,
	goalTerm VARCHAR(32),
	goalCode VARCHAR(64) NOT NULL,
	description VARCHAR(255),
	priorityLevel INT,
	targetDate DATE,
	targetAmt DOUBLE(11, 2),
	isAchieved BOOL,
	PRIMARY KEY(goalId),
	CONSTRAINT UniqueGoalCode UNIQUE (goalCode),
	CONSTRAINT assetFK1 FOREIGN KEY (assetId) REFERENCES Assets(assetId) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1
/;


-- STORED PROCEDURES --
DROP PROCEDURE IF EXISTS UpdateAssetAmount
/;
CREATE PROCEDURE UpdateAssetAmount (bsIdParam INT)
BEGIN
	UPDATE BalanceSheet
	SET
		assetAmt = (SELECT SUM(currentAmt) FROM Assets
							WHERE bsId=bsIdParam and isActive=true and isPaper=false
                            GROUP BY bsId),
		netWorth = (assetAmt-liabAmt)
	WHERE bsId = bsIdParam;
END
/;

DROP PROCEDURE IF EXISTS UpdateAssetGroupAmount
/;
CREATE PROCEDURE UpdateAssetGroupAmount (assetGroupIdParam INT)
BEGIN
	UPDATE AssetGroups
	SET
		assetSumAmt = (SELECT SUM(currentAmt) FROM Assets
						WHERE assetGroupId=assetGroupIdParam and isActive=true and isPaper=false
						GROUP BY assetGroupId)
	WHERE assetGroupId = assetGroupIdParam;
END
/;

DROP PROCEDURE IF EXISTS UpdateLiabilityAmount
/;
CREATE PROCEDURE UpdateLiabilityAmount (bsIdParam INT)
BEGIN
	UPDATE BalanceSheet
	SET
		liabAmt = (SELECT SUM(currentAmt) FROM Liabilities
						WHERE bsId=bsIdParam and isActive=true and isPaper=false
						GROUP BY bsId),
		netWorth = (assetAmt-liabAmt)
	WHERE bsId = bsIdParam;
END
/;

-- TRIGGERS --
DROP TRIGGER IF EXISTS AfterAssetInsert
/;
CREATE TRIGGER AfterAssetInsert
    AFTER INSERT ON Assets
    FOR EACH ROW
BEGIN
CALL UpdateAssetAmount(NEW.bsId);
CALL UpdateAssetGroupAmount(NEW.assetGroupId);
END
/;

DROP TRIGGER IF EXISTS AfterAssetUpdate
/;
CREATE TRIGGER AfterAssetUpdate
    AFTER UPDATE ON Assets
    FOR EACH ROW
BEGIN
CALL UpdateAssetAmount(NEW.bsId);
CALL UpdateAssetGroupAmount(NEW.assetGroupId);
END
/;

DROP TRIGGER IF EXISTS AfterLiabInsert
/;
CREATE TRIGGER AfterLiabInsert
    AFTER INSERT ON Liabilities
    FOR EACH ROW
BEGIN
CALL UpdateLiabilityAmount(NEW.bsId);
END
/;

DROP TRIGGER IF EXISTS AfterLiabUpdate
/;
CREATE TRIGGER AfterLiabUpdate
    AFTER UPDATE ON Liabilities
    FOR EACH ROW
BEGIN
CALL UpdateLiabilityAmount(NEW.bsId);
END