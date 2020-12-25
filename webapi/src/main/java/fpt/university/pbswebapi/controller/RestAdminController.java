package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.repository.ReturningTypeRepository;
import fpt.university.pbswebapi.repository.ThreadRepository;
import fpt.university.pbswebapi.repository.ThreadTopicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class RestAdminController {

    private ReturningTypeRepository returningTypeRepository;
    private ThreadTopicRepository topicRepository;
    private ThreadRepository threadRepository;

    @Autowired
    public RestAdminController(ReturningTypeRepository returningTypeRepository, ThreadTopicRepository topicRepository, ThreadRepository threadRepository) {
        this.returningTypeRepository = returningTypeRepository;
        this.topicRepository = topicRepository;
        this.threadRepository = threadRepository;
    }

    @RequestMapping("/admin/returning-types")
    public ResponseEntity<?> allReturningType() {
        return ResponseEntity.ok().body(returningTypeRepository.findAll());
    }

    @RequestMapping("/admin/thread-topics")
    public ResponseEntity<?> allTopics() {
        return ResponseEntity.ok().body(topicRepository.findAll());
    }

    @RequestMapping("/api/admin/threads")
    public ResponseEntity<?> allThreads() {
        return ResponseEntity.ok().body(threadRepository.findAll());
    }
}
