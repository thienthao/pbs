package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.DayOfWeek;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface WorkingDayRepository extends JpaRepository<DayOfWeek, Long> {

    @Query("from DayOfWeek dow where dow.photographer.id =:ptgId and dow.isWorkingDay=false")
    List<DayOfWeek> findNotWorkingDayByPhotographerId(Long ptgId);

    @Query("from DayOfWeek dow where dow.photographer.id =:ptgId")
    List<DayOfWeek> findAllByPhotographerId(Long ptgId);

    @Query("select count(dow) from DayOfWeek dow where dow.photographer.id =:ptgId and dow.day =:day")
    Long checkDowExists(long ptgId, int day);

    @Query("from DayOfWeek dow where dow.photographer.id =:ptgId and dow.day=:day")
    DayOfWeek findByPhotographerIdAndDay(Long ptgId, int day);

}
