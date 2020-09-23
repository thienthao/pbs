package fpt.university.pbswebapi;

import fpt.university.pbswebapi.domain.Album;
import fpt.university.pbswebapi.domain.Photographer;
import fpt.university.pbswebapi.domain.Portfolio;
import fpt.university.pbswebapi.domain.Project;
import fpt.university.pbswebapi.repository.AlbumRepository;
import fpt.university.pbswebapi.repository.PhotographerRepository;
import fpt.university.pbswebapi.repository.PortfolioRepository;
import fpt.university.pbswebapi.repository.ProjectRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class MyRunner implements CommandLineRunner {
    public Logger logger = LoggerFactory.getLogger(Logger.class);

    private PhotographerRepository phtrRepo;
    private AlbumRepository albumRepository;

    @Autowired
    public MyRunner(PhotographerRepository phtrRepo, AlbumRepository albumRepository) {
        this.phtrRepo = phtrRepo;
        this.albumRepository = albumRepository;
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

        var album1 = new Album(Long.parseLong("1"), null, null, u1);
        var album2 = new Album(Long.parseLong("2"), null, null, u1);
        var album3 = new Album(Long.parseLong("3"), null, null, u1);

        albumRepository.save(album1);
        albumRepository.save(album2);
        albumRepository.save(album3);
    }
}
