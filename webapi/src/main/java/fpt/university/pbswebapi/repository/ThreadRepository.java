package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.Thread;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ThreadRepository extends JpaRepository<Thread, Long> {
}
