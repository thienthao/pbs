package fpt.university.pbswebapi.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "busy_days")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BusyDay {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Temporal(TemporalType.DATE)
    @Column(name = "start_date")
    private Date startDate;

    @Temporal(TemporalType.DATE)
    @Column(name = "end_date")
    private Date endDate;

    private String title;

    private String description;

    @ManyToOne(optional = true)
    @JoinColumn(name = "photographer_id", referencedColumnName = "id")
    private User photographer;

}
