package ph.marupork.finance.repository;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.TestPropertySource;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.jdbc.SqlConfig;
import org.springframework.test.context.junit4.SpringRunner;
import ph.marupork.finance.entity.*;
import ph.marupork.finance.enums.AssetType;
import ph.marupork.finance.enums.GoalTerm;
import ph.marupork.finance.enums.LiabType;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.Month;
import java.util.Arrays;

@RunWith(SpringRunner.class)
@SpringBootTest
@TestPropertySource(locations = "classpath:application-test.properties")
@Sql(scripts = "classpath:/db/sql/schema.sql",
        config = @SqlConfig(separator = "/;"))
public class BalanceSheetRepositoryTests {

    @Autowired
    private GoalRepository goalRepository;

    @Autowired
    private BalanceSheetRepository balanceSheetRepository;

    @Autowired
    private AssetRepository assetRepository;

    @Autowired
    private AssetGroupRepository assetGroupRepository;

    @Autowired
    private LiabilityRepository liabilityRepository;

    @Test
    public void createGoal() {
        Goal eFundGoal = new Goal();
        eFundGoal.setGoalTerm(GoalTerm.SHORT_TERM);
        eFundGoal.setGoalCode("Emergency Fund");
        eFundGoal.setDescription("Complete Emergency fund");
        eFundGoal.setTargetAmt(BigDecimal.valueOf(100000.00));
        eFundGoal.setTargetDate(LocalDate.of(2020, Month.DECEMBER, 31));
        eFundGoal.setPriorityLevel(1);
        eFundGoal.setIsAchieved(false);

        goalRepository.save(eFundGoal);
        Assert.assertNotNull(eFundGoal.getGoalId());
    }

    @Test
    public void balanceSheetProcess() {

        // Add BALANCE SHEET
        BalanceSheet bsAsOfToday = new BalanceSheet();
        bsAsOfToday.setAsOfDate(LocalDate.now());
        bsAsOfToday.setAssetAmt(BigDecimal.ZERO);
        bsAsOfToday.setLiabAmt(BigDecimal.ZERO);
        bsAsOfToday.setNetWorth(BigDecimal.ZERO);

       balanceSheetRepository.save(bsAsOfToday);
       Assert.assertNotNull(bsAsOfToday.getBsId());

       // Add ASSET - Cash On Hand
        Asset cashOnHand = new Asset();
        cashOnHand.setBalanceSheet(bsAsOfToday);
        cashOnHand.setAssetType(AssetType.MONETARY);
        cashOnHand.setAssetCode("Cash on Hand");
        cashOnHand.setDescription("Cash available as of this moment");
        cashOnHand.setCurrentAmt(BigDecimal.valueOf(500.00));
        cashOnHand.setIsActive(true);
        cashOnHand.setIsPaper(false);

        assetRepository.save(cashOnHand);
        Assert.assertNotNull(cashOnHand.getAssetId());

        assertBalanceSheet(bsAsOfToday.getBsId(), BigDecimal.valueOf(500.00), BigDecimal.valueOf(0.0), BigDecimal.valueOf(500.00));

       // Add ASSET GROUP - BDO Savings Account
        AssetGroup bdoSaGroup = new AssetGroup();
        bdoSaGroup.setAssetGroupCode("BDO-SA");
        bdoSaGroup.setDescription("Group Holder for BDO Savings Account");
        bdoSaGroup.setCurrentAmt(BigDecimal.valueOf(10000));
        bdoSaGroup.setAssetSumAmt(BigDecimal.valueOf(10000));

        Asset bdoMaintainingBalance = new Asset();
        bdoMaintainingBalance.setBalanceSheet(bsAsOfToday);
        bdoMaintainingBalance.setAssetGroup(bdoSaGroup);
        bdoMaintainingBalance.setAssetType(AssetType.MONETARY);
        bdoMaintainingBalance.setAssetCode("Maintaining Balance");
        bdoMaintainingBalance.setDescription("Balance to maintain set by the bank");
        bdoMaintainingBalance.setCurrentAmt(BigDecimal.valueOf(2000));
        bdoMaintainingBalance.setIsActive(true);
        bdoMaintainingBalance.setIsPaper(false);

        bdoSaGroup.setAssets(Arrays.asList(bdoMaintainingBalance));

        assetGroupRepository.save(bdoSaGroup);
        Assert.assertNotNull(bdoSaGroup.getAssetGroupId());
        Assert.assertNotNull(bdoMaintainingBalance.getAssetId());

        assertBalanceSheet(bsAsOfToday.getBsId(), BigDecimal.valueOf(2500.00), BigDecimal.valueOf(0.0), BigDecimal.valueOf(2500.00));

        // Add LIABILITY - SSS Loan
        Liability sssLoan = new Liability();
        sssLoan.setBalanceSheet(bsAsOfToday);
        sssLoan.setLiabType(LiabType.LONG_TERM_DEBT);
        sssLoan.setLiabCode("SSS Loan");
        sssLoan.setDescription("SSS Salary Loan");
        sssLoan.setLiabAmt(BigDecimal.valueOf(16000));
        sssLoan.setCurrentAmt(BigDecimal.valueOf(1000));
        sssLoan.setIsActive(true);
        sssLoan.setIsPaper(false);

        liabilityRepository.save(sssLoan);
        Assert.assertNotNull(sssLoan.getLiabId());

        assertBalanceSheet(bsAsOfToday.getBsId(), BigDecimal.valueOf(2500.00), BigDecimal.valueOf(1000.00), BigDecimal.valueOf(1500.00));
    }

    private void assertBalanceSheet(Long bsAsOfTodayId, BigDecimal assetAmt, BigDecimal liabAmt, BigDecimal netWorth) {
        BalanceSheet actualBs = balanceSheetRepository.findById(bsAsOfTodayId)
                .orElse(null);
        Assert.assertNotNull(actualBs);

        Assert.assertEquals(assetAmt, actualBs.getAssetAmt());
        Assert.assertEquals(liabAmt, actualBs.getLiabAmt());
        Assert.assertEquals(netWorth, actualBs.getNetWorth());
    }
}

