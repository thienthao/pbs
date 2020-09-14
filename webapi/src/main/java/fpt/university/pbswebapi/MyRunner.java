package fpt.university.pbswebapi;

import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.domain.Portfolio;
import fpt.university.pbswebapi.domain.Project;
import fpt.university.pbswebapi.repository.PhotographerRepository;
import fpt.university.pbswebapi.repository.PortfolioRepository;
import fpt.university.pbswebapi.repository.ProjectRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class MyRunner implements CommandLineRunner {
    public Logger logger = LoggerFactory.getLogger(Logger.class);

    private PhotographerRepository phtrRepo;
    private PortfolioRepository portRepo;
    private ProjectRepository projectRepo;

    public MyRunner(PhotographerRepository phtrRepo, PortfolioRepository portRepo, ProjectRepository projectRepo) {
        this.phtrRepo = phtrRepo;
        this.portRepo = portRepo;
        this.projectRepo = projectRepo;
    }

    @Override
    public void run(String... args) throws Exception {
        logger.info("init data");

        var u1 = new Photographer(Long.parseLong("1"), "Thao");
        var u2 = new Photographer(Long.parseLong("2"), "Dat");
        var u3 = new Photographer(Long.parseLong("3"), "Kien");
        var u4 = new Photographer(Long.parseLong("4"), "My");

        phtrRepo.save(u1);
        phtrRepo.save(u2);
        phtrRepo.save(u3);
        phtrRepo.save(u4);

        var portfolio1 = new Portfolio(Long.parseLong("1"), "Thao's Summer 2020", u1);
        var portfolio2 = new Portfolio(Long.parseLong("2"), "Thao's Portfolio2", u1);
        var portfolio3 = new Portfolio(Long.parseLong("3"), "Thao's Portfolio3", u1);

        portRepo.save(portfolio1);
        portRepo.save(portfolio2);
        portRepo.save(portfolio3);

        var project1 = new Project(Long.parseLong("1"), "Thao's Project's 1", portfolio1);
        var project2 = new Project(Long.parseLong("2"), "Thao's Project's 2", portfolio1);
        var project3 = new Project(Long.parseLong("3"), "Thao's Project's 3", portfolio3);

        projectRepo.save(project1);
        projectRepo.save(project2);
        projectRepo.save(project3);
    }
}
