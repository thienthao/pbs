package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Report;
import fpt.university.pbswebapi.repository.ReportRepository;
import org.springframework.beans.factory.annotation.Autowired;
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

    public Report save(Report report) {
        report.setCreatedAt(new Date());
        return reportRepository.save(report);
    }
}