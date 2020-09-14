package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.domain.Project;
import fpt.university.pbswebapi.service.ProjectService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/projects")
public class ProjectController {
    private ProjectService projectService;

    public ProjectController(ProjectService projectService) {
        this.projectService = projectService;
    }

    @GetMapping
    public ResponseEntity<List<Project>> findAll() {
        return new ResponseEntity<List<Project>>(projectService.findAll(), HttpStatus.OK);
    }

    @GetMapping("/{name}")
    public ResponseEntity<List<Project>> findAllByNameContaining(String name) {
        return new ResponseEntity<List<Project>>(projectService.findAllByNameContaining(name), HttpStatus.OK);
    }
}
