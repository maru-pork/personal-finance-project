package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ph.marupork.finance.entity.BalanceSheet;

import javax.persistence.Id;

public interface BalanceSheetRepository extends JpaRepository<BalanceSheet, Id> {
}
