package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Report;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;

public interface ReportRepository extends JpaRepository<Report, Long> {

    @Query("select r from Report r order by r.createdAt desc")
    Page<Report> findAllOrderByReportedDate(Pageable pageable);

    @Transactional
    @Modifying
    @Query("update Report r set r.isSolve=true where r.id=:id")
    void seen(Long id);
}