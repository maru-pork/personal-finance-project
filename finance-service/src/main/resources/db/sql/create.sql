-- DROP SCHEMA IF EXISTS personal_finance;
-- CREATE SCHEMA personal_finance;
-- USE personal_finance;

CREATE TABLE BalanceSheet (
	bsId INT NOT NULL AUTO_INCREMENT,
	asOfDate DATE NOT NULL,
	isSubmitted BOOL DEFAULT 0,
	assetAmt DOUBLE(11, 2) NOT NULL DEFAULT 0.00,
	liabAmt DOUBLE(11, 2) NOT NULL DEFAULT 0.00,
	netWorth  DOUBLE(11, 2) NOT NULL DEFAULT 0.00,
	PRIMARY KEY(bsId)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

CREATE TABLE AssetGroups (
	assetGroupId  INT NOT NULL AUTO_INCREMENT,
	assetGroupCode VARCHAR(64) NOT NULL,
	description VARCHAR(255),
	currentAmt  DOUBLE(10, 2) NOT NULL,
	assetSumAmt DOUBLE(10, 2) NOT NULL,
	PRIMARY KEY(assetGroupId),
	CONSTRAINT UniqueAssetGroupCode UNIQUE (assetGroupCode)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=LATIN1;

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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=LATIN1;

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
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;

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
);

-- INSERT INTO BalanceSheet (asOfDate) VALUES (CURRENT_DATE);
-- SELECT @bs_id := max(bsId) from BalanceSheet;

-- INSERT INTO AssetGroups (assetGroupCode, assetSumAmt, currentAmt) VALUES ('BDO-SA', 10000.00, 10000.00);
-- SELECT @asg_id := max(assetGroupId) from AssetGroups;

-- INSERT INTO ASSETS (bsid, assetGroupId, assetType, assetCode, description, currentAmt) VALUES (@bs_id, @asg_id, 'MONETARY', 'Maintaining Balance', 'MB', 2000.00);
-- INSERT INTO ASSETS (bsid, assetType, assetCode, description, currentAmt) VALUES (@bs_id, 'MONETARY', 'Cash On Hand', 'COH', 100.00);

-- INSERT INTO LIABILITIES (bsId, liabType, liabCode, description, liabAmt, currentAmt) VALUES (1, 'SHORT_TERM', 'SSS Salary Loan', 'Salary Loan', 1000.00, 100.00);