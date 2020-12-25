package fpt.university.pbswebapi.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class CancelledBooking {

    private String customerName;

    private String customerAvatar;

    private String photographerName;

    private LocalDateTime cancelledAt;

    private LocalDateTime shootingAt;

    private String shootingLocation;

    private Integer price;

}
