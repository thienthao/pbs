package fpt.university.pbswebapi;

import fpt.university.pbswebapi.config.AppProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

@SpringBootApplication(exclude = {SecurityAutoConfiguration.class})
@EnableConfigurationProperties(AppProperties.class)
public class PbsWebapiApplication {

    public static void main(String[] args) {
        SpringApplication.run(PbsWebapiApplication.class, args);
    }
}
