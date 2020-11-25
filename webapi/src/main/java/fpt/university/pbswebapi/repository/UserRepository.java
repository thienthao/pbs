package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByUsername(String username);
    Boolean existsByUsername(String username);
    Boolean existsByEmail(String email);

    @Query("select distinct photographer " +
            "from User photographer " +
            "inner join photographer.locations location " +
            "where photographer.role.id =:roleId " +
            "and location.formattedAddress like %:city% " +
            "order by photographer.ratingCount desc")
    Page<User> findPhotographersInCityOrderByRating(Pageable paging, Long roleId, String city);

    @Query("select distinct photographer " +
            "from User photographer " +
            "where photographer.role.id =:roleId " +
            "order by photographer.ratingCount desc")
    Page<User> findPhotographersOrderByRating(Pageable paging, Long roleId);

    @Query("FROM User photographer where photographer.role.id =:roleId")
    List<User> findAllPhotographer(Long roleId);

    @Query("FROM User customer where customer.role.id =:roleId")
    List<User> findAllCustomers(Long roleId);

    @Query("select distinct photographer from User photographer " +
            "inner join photographer.packages package " +
            "inner join package.category category " +
            "inner join photographer.locations location " +
            "where category.id =:categoryId " +
            "and location.formattedAddress like %:city% " +
            "order by photographer.ratingCount desc")
    Page<User> findPhotographersByCategoryAndCitySortByRating(Pageable paging, long categoryId, String city);

    @Query("select distinct photographer from User photographer " +
            "inner join photographer.packages package " +
            "inner join package.category category " +
            "where category.id =:categoryId " +
            "order by photographer.ratingCount desc")
    Page<User> findPhotographersByCategorySortByRating(Pageable paging, long categoryId);

    @Query("FROM User photographer where photographer.role.id =:roleId and photographer.fullname like %:search% order by photographer.ratingCount desc")
    Page<User> searchPhotographerNameContaining(String search, Pageable paging, long roleId);

    @Transactional
    @Modifying
    @Query("update User user set user.isBlocked=true where user.id=:userId")
    void blockUser(long userId);

    @Transactional
    @Modifying
    @Query("update User user set user.isBlocked=false where user.id=:userId")
    void unblockUser(long userId);
}
