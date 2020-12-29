package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    List<Notification> getAllByReceiverId(Long receiverId);

    @Transactional
    @Modifying
    @Query("update Notification notification set notification.isRead=true where notification.id=:notiId")
    void setIsRead(long notiId);
}
