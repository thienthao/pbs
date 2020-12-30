package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.entity.Report;
import fpt.university.pbswebapi.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/reports")
public class ReportController {

    private final ReportService reportService;

    @Autowired
    public ReportController(ReportService reportService) {
        this.reportService = reportService;
    }

    @GetMapping
    public ResponseEntity<?> getAll() {
        return new ResponseEntity<>(reportService.getAll(), HttpStatus.OK);
    }

    @PostMapping
    public ResponseEntity<?> report(@RequestBody Report report) {
        return new ResponseEntity<>(reportService.save(report), HttpStatus.OK);
    }
}