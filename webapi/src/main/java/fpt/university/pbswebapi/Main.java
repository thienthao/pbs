package fpt.university.pbswebapi;

import fpt.university.pbswebapi.config.AppProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.autoconfigure.thymeleaf.ThymeleafProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.thymeleaf.templateresolver.FileTemplateResolver;
import org.thymeleaf.templateresolver.ITemplateResolver;

import java.util.TimeZone;

@SpringBootApplication(exclude = {SecurityAutoConfiguration.class})
@EnableConfigurationProperties(AppProperties.class)
@EnableCaching
@EnableScheduling
public class Main extends SpringBootServletInitializer {

//    @Autowired
//    private ThymeleafProperties thymeleafProperties;
//
//    @Value("${spring.thymeleaf.templates_root}")
//    private String templatesRoot;
//
//    @Bean
//    public ITemplateResolver defaultTemplateResolver() {
//        FileTemplateResolver resolver = new FileTemplateResolver();
//        resolver.setSuffix(thymeleafProperties.getSuffix());
//        resolver.setPrefix(templatesRoot);
//        resolver.setTemplateMode(thymeleafProperties.getMode());
//        resolver.setCacheable(thymeleafProperties.isCache());
//        return resolver;
//    }

    public static void main(String[] args) {
        SpringApplication.run(Main.class, args);
    }
}
