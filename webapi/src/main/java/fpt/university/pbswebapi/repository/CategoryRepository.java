package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CategoryRepository extends JpaRepository<Category, Long> {
}
