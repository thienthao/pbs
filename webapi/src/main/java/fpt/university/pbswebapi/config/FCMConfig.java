package fpt.university.pbswebapi.config;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import lombok.extern.log4j.Log4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;

import javax.annotation.PostConstruct;

@Configuration
public class FCMConfig {
    private Logger logger = LoggerFactory.getLogger(Logger.class);

    @Value("${app.firebase-configuration-file}")
    private String firebasePath;

    @PostConstruct
    public void init() {
        logger.info("Init FCM");
        try {
           GoogleCredentials googleCredentials = GoogleCredentials
                   .fromStream(new ClassPathResource(firebasePath).getInputStream());
           FirebaseOptions firebaseOptions = FirebaseOptions
                   .builder()
                   .setCredentials(googleCredentials)
                   .build();
            if(FirebaseApp.getApps().isEmpty()) {
                FirebaseApp.initializeApp(firebaseOptions);
                logger.info("Firebase app initialized");
            }
        } catch (Exception e) {
            logger.error(e.getMessage());
        }
    }
}
