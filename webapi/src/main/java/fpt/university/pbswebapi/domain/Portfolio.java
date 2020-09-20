package fpt.university.pbswebapi.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@Entity(name = "portfolios")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Portfolio {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @ManyToOne(optional = false)
    @JoinColumn(name = "PHOTOGRAPHER_ID", referencedColumnName = "ID")
    @JsonBackReference
    private Photographer photographer;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "portfolio")
    @JsonManagedReference
    private List<Project> projects;

    public Portfolio(Long id, String name, Photographer photographer) {
        this.id = id;
        this.name = name;
        this.photographer = photographer;
    }
}
