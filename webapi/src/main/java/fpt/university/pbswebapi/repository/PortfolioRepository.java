package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.domain.Portfolio;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface PortfolioRepository extends JpaRepository<Portfolio, Long> {
    List<Portfolio> findAllByNameContaining(String name);
}
