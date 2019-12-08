package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ph.marupork.finance.entity.Liability;

@Repository
public interface LiabilityRepository extends JpaRepository<Liability, Long> {
}
