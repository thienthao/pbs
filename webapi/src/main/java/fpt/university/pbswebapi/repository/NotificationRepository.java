package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Notification;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface NotificationRepository extends JpaRepository<Notification, Long> {

    List<Notification> getAllByReceiverId(Long receiverId);
}
