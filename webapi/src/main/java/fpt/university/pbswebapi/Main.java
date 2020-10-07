package fpt.university.pbswebapi;

import fpt.university.pbswebapi.config.AppProperties;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;

@SpringBootApplication(exclude = {SecurityAutoConfiguration.class})
@EnableConfigurationProperties(AppProperties.class)
@ComponentScan(basePackages = {"fpt.university"},
excludeFilters = @ComponentScan.Filter(type = FilterType.REGEX, pattern = {"fpt.university.pbswebapi.repository","fpt.university.pbswebapi.service","fpt.university.pbswebapi.controller"}))
public class Main {

    public static void main(String[] args) {
        SpringApplication.run(Main.class, args);
    }
}
