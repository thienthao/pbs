package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    @Autowired
    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @GetMapping("/{receiverId}")
    public ResponseEntity<?> findNotiWhereUserId(@PathVariable("receiverId") Long receiverId) {
        return new ResponseEntity<>(notificationService.findNotiWhereUserId(receiverId), HttpStatus.OK);
    }

    @PostMapping("/{bookingId}")
    public ResponseEntity<?> sendCheckinConfirmation(@PathVariable("bookingId") Long bookingId) {
        notificationService.createConfirmationNotification(bookingId);
        return new ResponseEntity<>("OK", HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public void setIsReadTrue(@PathVariable("id") Long id) {
        notificationService.setIsReadTrue(id);
    }
}
