package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ph.marupork.finance.entity.Goal;

@Repository
public interface GoalRepository extends JpaRepository<Goal, Long> {
}
