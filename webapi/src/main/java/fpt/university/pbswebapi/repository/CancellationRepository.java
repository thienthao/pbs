package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.CancellationRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface CancellationRepository extends JpaRepository<CancellationRequest, Long> {

    Page<CancellationRequest> findAllByIsSolveFalse(Pageable pageable);

    @Query("from CancellationRequest c where c.isSolve = false and c.createdAt>=:start and c.createdAt<=:end")
    Page<CancellationRequest> findAllByDate(Date start, Date end, Pageable pageable);
}
