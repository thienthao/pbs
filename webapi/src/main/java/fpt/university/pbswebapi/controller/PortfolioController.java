package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.Portfolio;
import fpt.university.pbswebapi.service.PortfolioService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/portfolios")
public class PortfolioController {
    private PortfolioService portfolioService;

    public PortfolioController(PortfolioService portfolioService) {
        this.portfolioService = portfolioService;
    }

    @GetMapping
    public ResponseEntity<List<Portfolio>> findAll() {
        return new ResponseEntity<List<Portfolio>>(portfolioService.findAll(), HttpStatus.OK);
    }

    @GetMapping("/{name}")
    public ResponseEntity<List<Portfolio>> findAllByNameContaining(@PathVariable String name) {
        return new ResponseEntity<List<Portfolio>>(portfolioService.findAllByNameContaining(name), HttpStatus.OK);
    }
}
