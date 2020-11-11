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
// ******************************************
// Object the hien mot ngay co booking de the hien lich cua photographer
// ******************************************
public class BookingDate {

    private Date bookedDate;

}
