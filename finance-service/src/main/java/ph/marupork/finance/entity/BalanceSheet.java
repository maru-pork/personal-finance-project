package ph.marupork.finance.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "BalanceSheet")
@Getter
@Setter
@NoArgsConstructor
public class BalanceSheet {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long bsId;

    @OneToMany(mappedBy = "balanceSheet")
    private List<Asset> assets = new ArrayList<>();

    @OneToMany(mappedBy = "balanceSheet")
    private List<Liability> liabilities = new ArrayList<>();

    @Column
    private LocalDate asOfDate;

    @Column
    private Boolean isSubmitted;

    @Column
    private BigDecimal assetAmt;

    @Column
    private BigDecimal liabAmt;

    @Column
    private BigDecimal netWorth;
}
