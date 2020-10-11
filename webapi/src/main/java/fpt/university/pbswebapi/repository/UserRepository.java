package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Boolean existsByUsername(String username);
    Boolean existsByEmail(String email);

    @Query("FROM User photographer where photographer.role.id =:roleId order by photographer.ratingCount desc")
    Page<User> findPhotographersByRating(Pageable paging, Long roleId);
}
