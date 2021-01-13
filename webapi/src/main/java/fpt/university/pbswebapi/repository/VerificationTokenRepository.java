package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.VerificationToken;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VerificationTokenRepository extends JpaRepository<VerificationToken, Long> {
    VerificationToken findByToken(String token);
    void removeByToken(String token);
}
