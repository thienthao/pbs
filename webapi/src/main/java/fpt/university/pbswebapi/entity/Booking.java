package fpt.university.pbswebapi.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.*;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "bookings")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "booking_status")
    private EBookingStatus bookingStatus;

    @Enumerated(EnumType.STRING)
    @Column(name = "previous_status")
    private EBookingStatus previousStatus;

    @Column(name = "start_date")
    private Date startDate;

    @Column(name = "end_date")
    private Date endDate;

    @Column(name = "service_name")
    private String serviceName;

    private Integer price;

    @Column(name = "returning_link")
    private String returningLink;

    @Column(name = "time_anticipate")
    private Integer timeAnticipate;

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

    private String location;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "edit_deadline")
    private Date editDeadline;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "comment_date")
    private Date commentDate;

    @ManyToOne(optional = false)
    @JoinColumn(name = "customer_id", referencedColumnName = "id")
    private User customer;

    @ManyToOne(optional = false)
    @JoinColumn(name = "photographer_id", referencedColumnName = "id")
    private User photographer;

    @ManyToOne(optional = false)
    @JoinColumn(name = "package_id", referencedColumnName = "id")
    private ServicePackage servicePackage;

    @ManyToOne(optional = false)
    @JoinColumn(name = "returning_type_id", referencedColumnName = "id")
    private ReturningType returningType;

    @OneToMany(cascade = CascadeType.ALL)
    @JoinColumn(name = "booking_id", referencedColumnName = "id")
    private List<BookingDetail> bookingDetails;

    @OneToMany(cascade = CascadeType.ALL)
    @JoinColumn(name = "booking_id", referencedColumnName = "id")
    private List<TimeLocationDetail> timeLocationDetails;

    @Column(name = "is_checkin")
    private Boolean isCheckin;

    @Column(name = "qr_checkin_code")
    private String qrCheckinCode;

    @PrePersist
    void prepersist() {
        isCheckin = false;
        createdAt = new Date();
    }

    public Booking(Long id, User customer, User photographer, ServicePackage servicePackage) {
        this.id = id;
        this.customer = customer;
        this.photographer = photographer;
        this.servicePackage = servicePackage;
    }

    @Override
    public String toString() {
        return "Booking{" +
                "id=" + id +
                ", bookingStatus=" + bookingStatus +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", serviceName='" + serviceName + '\'' +
                ", price=" + price +
                ", returningLink='" + returningLink + '\'' +
                ", timeAnticipate=" + timeAnticipate +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                ", customerCanceledReason='" + customerCanceledReason + '\'' +
                ", photographerCanceledReason='" + photographerCanceledReason + '\'' +
                ", rejectedReason='" + rejectedReason + '\'' +
                ", rating=" + rating +
                ", comment='" + comment + '\'' +
                ", location='" + location + '\'' +
                ", editDeadline=" + editDeadline +
                ", commentDate=" + commentDate +
                ", customer=" + customer +
                ", photographer=" + photographer +
                ", servicePackage=" + servicePackage +
                ", returningType=" + returningType +
                ", bookingDetails=" + bookingDetails +
                ", timeLocationDetails=" + timeLocationDetails +
                '}';
    }
}
