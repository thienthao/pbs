package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.service.PhotographerService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/photographers")
public class PhotographerController {
    private PhotographerService phtrService;

    public PhotographerController(PhotographerService phtrService) {
        this.phtrService = phtrService;
    }

    @GetMapping
    public ResponseEntity<List<Photographer>> findAll() {
        return new ResponseEntity<List<Photographer>>(phtrService.findAll(), HttpStatus.OK);
    }

    @GetMapping("/{name}")
    public ResponseEntity<List<Photographer>> findAllByNameContaining(@PathVariable String name) {
        return new ResponseEntity<List<Photographer>>(phtrService.findAllByNameContaining(name), HttpStatus.OK);
    }
}
