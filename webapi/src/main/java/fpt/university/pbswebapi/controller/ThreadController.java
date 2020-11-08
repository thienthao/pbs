package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.service.ThreadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ThreadController {

    private final ThreadService threadService;

    @Autowired
    public ThreadController(ThreadService threadService) {
        this.threadService = threadService;
    }

    @GetMapping("/threads")
    public ResponseEntity<?> all() {
        return new ResponseEntity<>(threadService.all(), HttpStatus.OK);
    }

    @GetMapping("/thread-topics")
    public ResponseEntity<?> allTopics() {
        return new ResponseEntity<>(threadService.allTopics(), HttpStatus.OK);
    }
}
