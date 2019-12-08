package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ph.marupork.finance.entity.Liability;

public interface LiabilityRepository extends JpaRepository<Liability, Long> {
}
