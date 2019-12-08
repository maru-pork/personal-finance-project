package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ph.marupork.finance.entity.AssetGroup;

public interface AssetGroupRepository extends JpaRepository<AssetGroup, Long> {
}
