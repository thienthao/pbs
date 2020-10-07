package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.ERole;
import fpt.university.pbswebapi.entity.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface RoleRepository extends JpaRepository<Role, Long> {
    Optional<Role> findByRole(ERole role);
}
