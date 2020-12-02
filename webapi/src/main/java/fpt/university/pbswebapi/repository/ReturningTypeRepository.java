package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.ReturningType;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReturningTypeRepository extends JpaRepository<ReturningType, Long> {

    ReturningType findById(Integer id);
}
