package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Report;
import fpt.university.pbswebapi.repository.ReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class ReportService {

    private final ReportRepository reportRepository;

    @Autowired
    public ReportService(ReportRepository reportRepository) {
        this.reportRepository = reportRepository;
    }

    public List<Report> getAll() {
        return reportRepository.findAll();
    }

    public Report findById(Long id) {
        return reportRepository.findById(id).get();
    }

    public Report save(Report report) {
        return reportRepository.save(report);
    }

    public Page<Report> getAll(Pageable pageable) {
        return reportRepository.findAll(pageable);
    }
}