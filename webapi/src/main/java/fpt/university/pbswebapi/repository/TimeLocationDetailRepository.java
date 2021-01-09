package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.TimeLocationDetail;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;

public interface TimeLocationDetailRepository extends JpaRepository<TimeLocationDetail, Long> {

    @Transactional
    @Modifying
    @Query("update TimeLocationDetail tld set tld.isCheckin=true where tld.id=:tldId")
    void checkin(Long tldId);
}
