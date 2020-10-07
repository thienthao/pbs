package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;

public interface BookingRepository extends JpaRepository<Booking, Long> {
}
