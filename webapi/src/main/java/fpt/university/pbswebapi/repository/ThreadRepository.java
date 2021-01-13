package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Thread;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;

public interface ThreadRepository extends JpaRepository<Thread, Long> {

    List<Thread> findAllByIsDeletedFalseAndIsBanFalse();

    @Query("from threads t where t.owner.id=:userId and t.isDeleted=false and t.isBan=false")
    List<Thread> findAllByUserId(long userId);

    @Transactional
    @Modifying
    @Query("update threads t set t.isDeleted=true where t.id=:threadId")
    void removeThread(long threadId);

    @Transactional
    @Modifying
    @Query("update threads t set t.isBan=true where t.id=:threadId")
    void banThread(long threadId);

    @Transactional
    @Modifying
    @Query("update threads t set t.isBan=false where t.id=:threadId")
    void unbanThread(long threadId);
}
