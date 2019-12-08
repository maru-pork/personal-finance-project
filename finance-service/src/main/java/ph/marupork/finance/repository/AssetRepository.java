package ph.marupork.finance.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ph.marupork.finance.entity.Asset;

public interface AssetRepository extends JpaRepository<Asset, Long> {
}
