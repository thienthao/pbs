package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.domain.Project;
import fpt.university.pbswebapi.repository.ProjectRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProjectService {
    private ProjectRepository projectRepo;

    public ProjectService(ProjectRepository projectRepo) {
        this.projectRepo = projectRepo;
    }

    public List<Project> findAll() {
        return projectRepo.findAll();
    }

    public List<Project> findAllByNameContaining(String name) {
        return projectRepo.findAllByNameContaining(name);
    }
}
