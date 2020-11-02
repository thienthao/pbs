package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface LocationRepository extends JpaRepository<Location, Long> {

    @Query("from Location location where location.user.id =:userId")
    List<Location> findAllByUserId(long userId);
}
