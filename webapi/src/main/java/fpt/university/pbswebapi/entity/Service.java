package fpt.university.pbswebapi.entity;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "services")
@Data
@NoArgsConstructor
@AllArgsConstructor
@JsonIdentityInfo(
        generator = ObjectIdGenerators.PropertyGenerator.class,
        property = "id"
)
public class Service {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "service_name")
    private String name;

    private String description;

    @Column(name = "is_active")
    private Boolean isActive;

    @ManyToMany(mappedBy = "services")
    private List<ServicePackage> servicePackages;

    public Service(String name, String description) {
        this.name = name;
        this.description = description;
    }

    @PrePersist
    void prepersist() {
        isActive = true;
    }
}
