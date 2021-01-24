package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.repository.ReturningTypeRepository;
import fpt.university.pbswebapi.repository.ThreadRepository;
import fpt.university.pbswebapi.repository.ThreadTopicRepository;
import fpt.university.pbswebapi.service.CancellationService;
import fpt.university.pbswebapi.service.EmailService;
import fpt.university.pbswebapi.service.VariableService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@RestController
public class RestAdminController {

    private ReturningTypeRepository returningTypeRepository;
    private ThreadTopicRepository topicRepository;
    private ThreadRepository threadRepository;
    private CancellationService cancellationService;
    private VariableService variableService;

    @Autowired
    public RestAdminController(ReturningTypeRepository returningTypeRepository, ThreadTopicRepository topicRepository, ThreadRepository threadRepository, CancellationService cancellationService, VariableService variableService) {
        this.returningTypeRepository = returningTypeRepository;
        this.topicRepository = topicRepository;
        this.threadRepository = threadRepository;
        this.cancellationService = cancellationService;
        this.variableService = variableService;
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

    @PostMapping("/admin/api/cancellations/{id}")
    public ResponseEntity<?> showCancellationDetailAfterApprove(@PathVariable Long id) {
        try {
            cancellationService.approve(id);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return new ResponseEntity<>("Đã có lỗi xảy ra", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/admin/api/cancellations-warn/{id}")
    public ResponseEntity<?> warnAndShowCancellationDetail(@PathVariable Long id, @RequestBody String mail) {
        try {
            cancellationService.warn(id, mail);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return new ResponseEntity<>("Đã có lỗi xảy ra", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/admin/api/variables")
    public ResponseEntity<?> updateVariable(@RequestParam Float rating, @RequestParam Float price, @RequestParam Float distance) {
        try {
            variableService.saveAll(rating, price, distance);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return new ResponseEntity<>("Đã có lỗi xảy ra", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
