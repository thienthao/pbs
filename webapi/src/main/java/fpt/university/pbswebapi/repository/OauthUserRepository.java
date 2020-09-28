package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.domain.OAuthUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

public interface OauthUserRepository extends JpaRepository<OAuthUser, Long> {
    Optional<OAuthUser> findByEmail(String email);

    Boolean existsByEmail(String email);
}
