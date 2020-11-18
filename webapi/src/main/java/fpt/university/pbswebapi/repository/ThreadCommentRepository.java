package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.ThreadComment;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ThreadCommentRepository extends JpaRepository<ThreadComment, Long> {
}
