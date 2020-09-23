package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.domain.ERole;
import fpt.university.pbswebapi.domain.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByName(ERole name);
}
