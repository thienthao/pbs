package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
// Object the hien info cua mot booking
public class BookingInfo {

    private long id;

    private long customerId;

    private String status;

    private String customerName;

    private String packageName;

    private Integer packagePrice;

    private String address;

    private Double lat;

    private Double lon;

    private Date start;

    private Date end;
}
