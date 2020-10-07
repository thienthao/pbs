package fpt.university.pbswebapi;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

//@Component
public class MyRunner implements CommandLineRunner {
    public Logger logger = LoggerFactory.getLogger(Logger.class);



    @Override
    public void run(String... args) throws Exception {
        logger.info("init data");
//
//        var u1 = new Photographer(Long.parseLong("1"), "Thao");
//        var u2 = new Photographer(Long.parseLong("2"), "Dat");
//        var u3 = new Photographer(Long.parseLong("3"), "Kien");
//        var u4 = new Photographer(Long.parseLong("4"), "My");
//
//        phtrRepo.save(u1);
//        phtrRepo.save(u2);
//        phtrRepo.save(u3);
//        phtrRepo.save(u4);
//
//        var photo1 = new Photo(Long.parseLong("1"), "image caption 1", " image link 1");
//        var photo2 = new Photo(Long.parseLong("2"), "image caption 2", " image link 2");
//        var photo3 = new Photo(Long.parseLong("3"), "image caption 3", " image link 3");
//        var photo4 = new Photo(Long.parseLong("4"), "image caption 4", " image link 4");
//
//        List<Photo> photos1 = new ArrayList<>();
//        photos1.add(photo1);
//        photos1.add(photo2);
//        photos1.add(photo3);
//        photos1.add(photo4);
//
//        photoRepository.save(photo1);
//        photoRepository.save(photo2);
//        photoRepository.save(photo3);
//        photoRepository.save(photo4);
//
//        var album1 = new Album(Long.parseLong("1"), "Album Name 1", "thumbnaillink", u1, photos1);
////        var album2 = new Album(Long.parseLong("2"), "Album Name 2", null);
////        var album3 = new Album(Long.parseLong("3"), u3, null);
//
//        albumRepository.save(album1);
////        albumRepository.save(album2);
////        albumRepository.save(album3);
    }
}
