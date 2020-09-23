package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.domain.OAuthUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface OauthUserRepository extends JpaRepository<OAuthUser, Long> {
    Optional<OAuthUser> findByEmail(String email);

    Boolean existsByEmail(String email);
}
