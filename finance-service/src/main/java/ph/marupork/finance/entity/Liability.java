package ph.marupork.finance.entity;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import ph.marupork.finance.enums.LiabType;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "Liabilities")
@Getter
@Setter
@NoArgsConstructor
public class Liability {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long liabId;

    @ManyToOne
    @JoinColumn(name = "bsId")
    private BalanceSheet balanceSheet;

    @Enumerated(EnumType.STRING)
    @Column
    private LiabType liabType;

    @Column
    private String liabCode;

    @Column
    private String description;

    @Column
    private BigDecimal liabAmt;

    @Column
    private BigDecimal currentAmt;

    @Column
    private Boolean isActive;

    @Column
    private Boolean isPaper;

}
