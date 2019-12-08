package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ph.marupork.finance.entity.AssetGroup;

@Repository
public interface AssetGroupRepository extends JpaRepository<AssetGroup, Long> {
}
