package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import ph.marupork.finance.entity.Asset;

@Repository
public interface AssetRepository extends JpaRepository<Asset, Long> {
}
