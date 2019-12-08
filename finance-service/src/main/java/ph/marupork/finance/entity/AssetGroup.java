package ph.marupork.finance.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "AssetGroups")
@Getter
@Setter
@NoArgsConstructor
public class AssetGroup {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long assetGroupId;

    @Column
    private String assetGroupCode;

    @Column
    private String description;

    @Column
    private BigDecimal currentAmt;

    @Column
    private BigDecimal assetSumAmt;
}
