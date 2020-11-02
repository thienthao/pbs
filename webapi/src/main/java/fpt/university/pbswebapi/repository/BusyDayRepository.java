package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.BusyDay;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Date;
import java.util.List;

public interface BusyDayRepository extends JpaRepository<BusyDay, Long> {

    @Query("from BusyDay busyday where busyday.photographer.id =:ptgId and busyday.startDate between :from and :to")
    List<BusyDay> findByPhotographerIdBetweenStartDateEndDate(Long ptgId, Date from, Date to);

    @Query("from BusyDay busyday where busyday.photographer.id =:ptgId and busyday.startDate >:since")
    List<BusyDay> findByPhotographerIdSinceStartDate(Long ptgId, Date since);

    @Query("from BusyDay busyday where busyday.photographer.id =:ptgId order by busyday.startDate asc")
    List<BusyDay> findAllByPhotographerId(Long ptgId);
}
