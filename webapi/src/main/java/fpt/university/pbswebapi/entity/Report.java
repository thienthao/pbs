package fpt.university.pbswebapi.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;


@Entity
@Table(name = "reports")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Report {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title")
    private String title;

    @Column(name = "reason")
    private String reason;

    @ManyToOne(optional = false)
    @JoinColumn(name = "reporter_id", referencedColumnName = "id")
    private User reporter;

    @ManyToOne(optional = false)
    @JoinColumn(name = "booking_id", referencedColumnName = "id")
    private Booking booking;

    @Column(name = "is_solve")
    private Boolean isSolve;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at")
    private Date createdAt;

    @PrePersist
    void prepersist() {
        createdAt = new Date();
        isSolve = false;
    }
}