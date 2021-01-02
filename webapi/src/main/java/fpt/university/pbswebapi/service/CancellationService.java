package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.CancellationRequest;
import fpt.university.pbswebapi.helper.DateHelper;
import fpt.university.pbswebapi.repository.CancellationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Date;
import java.util.List;

@Service
public class CancellationService {

    private final CancellationRepository cancellationRepository;

    @Autowired
    public CancellationService(CancellationRepository cancellationRepository) {
        this.cancellationRepository = cancellationRepository;
    }

    private Page<CancellationRequest> getAll(Pageable pageable) {
        return cancellationRepository.findAllByIsSolveFalse(pageable);
    }

    private Page<CancellationRequest> getByDate(Pageable pageable, String start, String end) {
        String fromStr = start + " 00:00";
        String toStr = end + " 23:59";
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
        LocalDateTime localFrom = LocalDateTime.parse(fromStr, formatter);
        LocalDateTime localTo = LocalDateTime.parse(toStr, formatter);
        Date from = DateHelper.convertToDateViaInstant(localFrom);
        Date to = DateHelper.convertToDateViaInstant(localTo);
        return cancellationRepository.findAllByDate(from, to, pageable);
    }

    public Page<CancellationRequest> getAll(Pageable pageable, String start, String end) {
        if(start.equalsIgnoreCase("") || end.equalsIgnoreCase("")){
            return getAll(pageable);
        }

        return getByDate(pageable, start, end);
    }


    public Object findById(Long id) {
        return cancellationRepository.findById(id).get();
    }
}
