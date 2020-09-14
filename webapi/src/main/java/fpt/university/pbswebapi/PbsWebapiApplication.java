package fpt.university.pbswebapi;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.hibernate5.Hibernate5Module;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class PbsWebapiApplication {

    public static void main(String[] args) {
        SpringApplication.run(PbsWebapiApplication.class, args);
    }
}
