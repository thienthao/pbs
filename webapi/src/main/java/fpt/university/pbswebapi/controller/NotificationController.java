package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/notification")
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
}
