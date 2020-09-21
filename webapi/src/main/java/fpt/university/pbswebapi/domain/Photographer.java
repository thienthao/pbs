package fpt.university.pbswebapi.domain;


import com.fasterxml.jackson.annotation.JsonManagedReference;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import javax.persistence.*;
import java.util.List;

@Entity(name = "photographers")
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Photographer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name")
    private String name;

    @OneToMany(fetch = FetchType.LAZY, mappedBy = "photographer")
    @JsonManagedReference
    private List<Portfolio> portfolios;

    public Photographer(Long id, String name) {
        this.id = id;
        this.name = name;
    }
}
