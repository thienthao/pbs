package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Report;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReportRepository extends JpaRepository<Report, Long> {
}