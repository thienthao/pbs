package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Thread;
import fpt.university.pbswebapi.entity.ThreadTopic;
import fpt.university.pbswebapi.repository.ThreadRepository;
import fpt.university.pbswebapi.repository.ThreadTopicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ThreadService {
    private final ThreadRepository threadRepository;
    private final ThreadTopicRepository topicRepository;

    @Autowired
    public ThreadService(ThreadRepository threadRepository, ThreadTopicRepository topicRepository) {
        this.threadRepository = threadRepository;
        this.topicRepository = topicRepository;
    }

    public List<Thread> all() {
        return threadRepository.findAll();
    }

    public List<ThreadTopic> allTopics() {
        return topicRepository.findAll();
    }
}
