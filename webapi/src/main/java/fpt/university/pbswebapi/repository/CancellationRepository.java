package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.CancellationRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;

public interface CancellationRepository extends JpaRepository<CancellationRequest, Long> {

    @Query("Select c from CancellationRequest c order by c.createdAt desc")
    Page<CancellationRequest> findAll(Pageable pageable);

    @Query("Select c from CancellationRequest c where c.isSolve = false order by c.createdAt desc")
    Page<CancellationRequest> findAllByIsSolveFalse(Pageable pageable);

    @Query("Select c from CancellationRequest c where c.isSolve = true order by c.createdAt desc")
    Page<CancellationRequest> findAllByIsSolveTrue(Pageable pageable);

    @Query("from CancellationRequest c where c.isSolve = false and c.createdAt>=:start and c.createdAt<=:end order by c.createdAt desc")
    Page<CancellationRequest> findAllByDateNotSolve(Date start, Date end, Pageable pageable);

    @Query("from CancellationRequest c where c.isSolve = true and c.createdAt>=:start and c.createdAt<=:end order by c.createdAt desc")
    Page<CancellationRequest> findAllByDateSolve(Date start, Date end, Pageable pageable);

    @Query("from CancellationRequest c where c.createdAt>=:start and c.createdAt<=:end order by c.createdAt desc")
    Page<CancellationRequest> findAllByDate(Date start, Date end, Pageable pageable);

    @Query("select count(c) from CancellationRequest c where c.booking.id=:bookingId")
    Long countCancellation(Long bookingId);
}
