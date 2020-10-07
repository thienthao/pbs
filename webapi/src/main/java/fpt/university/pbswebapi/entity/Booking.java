package fpt.university.pbswebapi.entity;

import lombok.Data;

import javax.persistence.*;
import java.util.Date;

@Entity
@Table(name = "bookings")
@Data
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "start_date")
    private Date startDate;

    @Column(name = "end_date")
    private Date endDate;

    @Column(name = "service_name")
    private String serviceName;

    private Integer price;

    @Column(name = "created_at")
    private Date createdAt;

    @Column(name = "updated_at")
    private Date updatedAt;

    @Column(name = "customer_canceled_reason")
    private String customerCanceledReason;

    @Column(name = "photographer_canceled_reason")
    private String photographerCanceledReason;

    @Column(name = "rejected_reason")
    private String rejectedReason;

    private Float rating;

    private String comment;

    @ManyToOne(optional = false)
    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    private User customer;

    @ManyToOne(optional = false)
    @JoinColumn(name = "photographer_id", referencedColumnName = "id")
    private User photographer;

    @ManyToOne(optional = false)
    @JoinColumn(name = "package_id", referencedColumnName = "id")
    private ServicePackage servicePackage;
}
