package ph.marupork.finance.entity;


import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import ph.marupork.finance.enums.AssetType;

import javax.persistence.*;
import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@Entity
@Table(name = "Assets")
public class Asset {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long assetId;

    @ManyToOne
    @JoinColumn(name = "assetGroupId")
    private AssetGroup assetGroup;

    @ManyToOne
    @JoinColumn(name = "bsId")
    private BalanceSheet balanceSheet;

    @Enumerated(EnumType.STRING)
    @Column
    private AssetType assetType;

    @Column
    private String assetCode;

    @Column
    private String description;

    @Column
    private BigDecimal currentAmt;

    @Column
    private Boolean isActive;

    @Column
    private Boolean isPaper;

}
