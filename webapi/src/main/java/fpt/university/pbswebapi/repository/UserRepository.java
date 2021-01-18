package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Boolean existsByUsername(String username);
    Boolean existsByEmail(String email);

    Optional<User> findByUsername(String username);

    Optional<User> findByUsernameAndIsBlockedFalse(String username);

    @Query("select u from User u where u.role.role = 'ROLE_CUSTOMER'")
    Page<User> getCustomer(Pageable pageable);

    @Query("select u from User u where u.role.role = 'ROLE_CUSTOMER' and u.createdAt>=:from and u.createdAt<=:to")
    Page<User> getCustomerByDate(Pageable pageable, Date from, Date to);

    @Query("select u from User u where u.role.role = 'ROLE_PHOTOGRAPHER'")
    Page<User> getPhotographer(Pageable pageable);

    @Query("select u from User u where u.role.role = 'ROLE_PHOTOGRAPHER' and u.createdAt>=:from and u.createdAt<=:to")
    Page<User> getPhotographerByDate(Pageable pageable, Date from, Date to);

    @Query("select u from User u where u.role.role <> 'ROLE_ADMIN'")
    Page<User> getPhotographerAndCustomer(Pageable pageable);

    @Query("select u from User u where u.role.role <> 'ROLE_ADMIN' and u.createdAt>=:from and u.createdAt<=:to")
    Page<User> getPhotographerAndCustomerByDate(Pageable pageable, Date from, Date to);

    @Query("select u from User u where u.isBlocked =:isBlocked and u.username=':username'")
    Optional<User> findByusername(String username, int isBlocked);

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
            "where category.id =:category ")
    List<User> findPhotographerWithCategoryAndRole(Long category);

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

    User findByUsernameAndIsDeletedFalseAndIsBlockedFalse(String username);

    @Transactional
    @Modifying
    @Query("update User user set user.isEnabled=true where user.id=:userId")
    User enable(Long userId);
}
