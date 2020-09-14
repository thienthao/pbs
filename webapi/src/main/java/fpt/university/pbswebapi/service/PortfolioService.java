package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.domain.Portfolio;
import fpt.university.pbswebapi.repository.PortfolioRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PortfolioService {
    private PortfolioRepository portfoRepo;

    public PortfolioService(PortfolioRepository portfoRepo) {
        this.portfoRepo = portfoRepo;
    }

    public List<Portfolio> findAll() {
        return portfoRepo.findAll();
    }

    public List<Portfolio> findAllByNameContaining(String name) {
        return portfoRepo.findAllByNameContaining(name);
    }
}
