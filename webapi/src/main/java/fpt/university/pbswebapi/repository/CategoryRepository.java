package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface CategoryRepository extends JpaRepository<Category, Long> {

    List<Category> findAllByIsAvailableTrue();
}
