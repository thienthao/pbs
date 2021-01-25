package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.CancellationRequest;
import fpt.university.pbswebapi.entity.Report;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.Date;

public interface ReportRepository extends JpaRepository<Report, Long> {

    @Query("select r from Report r order by r.createdAt desc")
    Page<Report> findAllOrderByReportedDate(Pageable pageable);

    @Transactional
    @Modifying
    @Query("update Report r set r.isSolve=true where r.id=:id")
    void seen(Long id);

    @Query("Select r from Report r where r.isSolve = false order by r.createdAt desc")
    Page<Report> findAllByIsSolveFalse(Pageable pageable);

    @Query("Select r from Report r where r.isSolve = true order by r.createdAt desc")
    Page<Report> findAllByIsSolveTrue(Pageable pageable);

    @Query("from Report r where r.isSolve = false and r.createdAt>=:start and r.createdAt<=:end order by r.createdAt desc")
    Page<Report> findAllByDateNotSolve(Date start, Date end, Pageable pageable);

    @Query("from Report r where r.isSolve = true and r.createdAt>=:start and r.createdAt<=:end order by r.createdAt desc")
    Page<Report> findAllByDateSolve(Date start, Date end, Pageable pageable);

    @Query("from Report r where r.createdAt>=:start and r.createdAt<=:end order by r.createdAt desc")
    Page<Report> findAllByDate(Date start, Date end, Pageable pageable);
}