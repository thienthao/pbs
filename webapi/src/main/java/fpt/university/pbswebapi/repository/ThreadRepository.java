package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Thread;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;

public interface ThreadRepository extends JpaRepository<Thread, Long> {

    @Transactional
    @Modifying
    @Query("update threads t set t.isBan=true where t.id=:threadId")
    void banThread(long threadId);

    @Transactional
    @Modifying
    @Query("update threads t set t.isBan=false where t.id=:threadId")
    void unbanThread(long threadId);
}
