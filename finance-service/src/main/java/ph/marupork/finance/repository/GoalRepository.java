package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ph.marupork.finance.entity.Goal;

public interface GoalRepository extends JpaRepository<Goal, Long> {
}
