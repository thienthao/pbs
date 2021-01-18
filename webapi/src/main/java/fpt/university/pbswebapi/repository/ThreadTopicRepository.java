package fpt.university.pbswebapi.repository;

import fpt.university.pbswebapi.entity.ThreadTopic;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ThreadTopicRepository extends JpaRepository<ThreadTopic, Long> {

    List<ThreadTopic> findAllByIsAvailableTrue();
}
