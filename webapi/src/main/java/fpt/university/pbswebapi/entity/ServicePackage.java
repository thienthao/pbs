package fpt.university.pbswebapi.entity;

import com.fasterxml.jackson.annotation.JsonIdentityInfo;
import com.fasterxml.jackson.annotation.ObjectIdGenerators;
import lombok.*;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "photographer_packages")
@Getter
@Setter
@JsonIdentityInfo(
        generator = ObjectIdGenerators.PropertyGenerator.class,
        property = "id"
)
@NoArgsConstructor
@AllArgsConstructor
public class ServicePackage {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "package_name")
    private String name;

    @Column(name = "package_price")
    private Integer price;

    private String description;

    @Column(name = "is_available")
    private Boolean isAvailable;

    @Column(name = "support_multi_days")
    private Boolean supportMultiDays;

    @Temporal(value = TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @Temporal(value = TemporalType.TIMESTAMP)
    @Column(name = "updated_at")
    private Date updatedAt;

    @ManyToOne(optional = true)
    @JoinColumn(name = "photographer_id", referencedColumnName = "id", nullable = true)
    private User photographer;

    @ManyToMany(cascade = CascadeType.ALL)
    @JoinTable(
            name = "packages_services",
            joinColumns = @JoinColumn(name = "package_id"),
            inverseJoinColumns = @JoinColumn(name = "service_id")
    )
    private List<Service> services;

    @ManyToOne(optional = true)
    @JoinColumn(name = "category_id", referencedColumnName = "id")
    private Category category;

    public ServicePackage(String name, Integer price, String description, User photographer, List<Service> services) {
        this.name = name;
        this.price = price;
        this.description = description;
        this.photographer = photographer;
        this.services = services;
    }
}
