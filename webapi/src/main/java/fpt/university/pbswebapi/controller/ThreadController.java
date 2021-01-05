package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.entity.Thread;
import fpt.university.pbswebapi.entity.ThreadComment;
import fpt.university.pbswebapi.repository.ThreadCommentRepository;
import fpt.university.pbswebapi.service.ThreadService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api")
public class ThreadController {

    private final ThreadService threadService;
    private final ThreadCommentRepository threadCommentRepository;

    @Autowired
    public ThreadController(ThreadService threadService, ThreadCommentRepository threadCommentRepository) {
        this.threadService = threadService;
        this.threadCommentRepository = threadCommentRepository;
    }

    @GetMapping("/threads")
    public ResponseEntity<?> all() {
        return new ResponseEntity<>(threadService.all(), HttpStatus.OK);
    }

    @GetMapping("/threads/user/{userId}")
    public ResponseEntity<?> allByUserId(@PathVariable("userId") long userId) {
        return new ResponseEntity<>(threadService.allByUserId(userId), HttpStatus.OK);
    }

    @GetMapping("/thread-topics")
    public ResponseEntity<?> allTopics() {
        return new ResponseEntity<>(threadService.allTopics(), HttpStatus.OK);
    }

    @PostMapping("/threads")
    public ResponseEntity<?> createThread(@RequestBody Thread thread) {
        return new ResponseEntity<>(threadService.save(thread), HttpStatus.OK);
    }

    @PutMapping("/threads")
    public ResponseEntity<?> editThread(@RequestBody Thread thread) {
        return new ResponseEntity<>(threadService.edit(thread), HttpStatus.OK);
    }

    @DeleteMapping("/threads/{id}")
    public ResponseEntity<?> editThread(@PathVariable Long id) {
        return new ResponseEntity<>(threadService.remove(id), HttpStatus.OK);
    }

    @GetMapping("/threads/comments/json")
    public ResponseEntity<?> getThreadCommentJson() {
        return new ResponseEntity<>(threadCommentRepository.findAll(), HttpStatus.OK);
    }

    @PostMapping("/threads/comments")
    public ResponseEntity<?> postComment(@RequestBody ThreadComment comment) {
        return new ResponseEntity<>(threadService.postComment(comment), HttpStatus.OK);
    }

}
