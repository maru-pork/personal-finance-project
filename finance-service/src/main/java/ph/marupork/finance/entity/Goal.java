package ph.marupork.finance.entity;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import ph.marupork.finance.enums.GoalTerm;

import javax.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "Goals")
@Getter
@Setter
@NoArgsConstructor
public class Goal {

    @Id
    @Column
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long goalId;

    @OneToOne
    @JoinColumn(name = "assetId")
    private Asset asset;

    @Enumerated(EnumType.STRING)
    @Column
    private GoalTerm goalTerm;

    @Column
    private String goalCode;

    @Column
    private String description;

    @Column
    private Integer priorityLevel;

    @Column
    private LocalDate targetDate;

    @Column
    private BigDecimal targetAmt;

    @Column
    private Boolean isAchieved;

}
