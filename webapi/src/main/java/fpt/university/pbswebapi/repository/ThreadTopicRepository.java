package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.ThreadTopic;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ThreadTopicRepository extends JpaRepository<ThreadTopic, Long> {
}
