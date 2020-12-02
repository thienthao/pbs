package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Thread;
import fpt.university.pbswebapi.entity.ThreadComment;
import fpt.university.pbswebapi.entity.ThreadTopic;
import fpt.university.pbswebapi.repository.ThreadCommentRepository;
import fpt.university.pbswebapi.repository.ThreadRepository;
import fpt.university.pbswebapi.repository.ThreadTopicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ThreadService {
    private final ThreadRepository threadRepository;
    private final ThreadTopicRepository topicRepository;
    private final ThreadCommentRepository threadCommentRepository;

    @Autowired
    public ThreadService(ThreadRepository threadRepository, ThreadTopicRepository topicRepository, ThreadCommentRepository threadCommentRepository) {
        this.threadRepository = threadRepository;
        this.topicRepository = topicRepository;
        this.threadCommentRepository = threadCommentRepository;
    }

    public List<Thread> all() {
        return threadRepository.findAll();
    }

    public List<ThreadTopic> allTopics() {
        return topicRepository.findAll();
    }

    public Thread findById(long id) {
        return threadRepository.findById(id).get();
    }

    public Thread save(Thread thread) {
        return threadRepository.save(thread);
    }

    public ThreadComment postComment(ThreadComment comment) {
        return threadCommentRepository.save(comment);
    }

    public void banThread(long threadId) {
        threadRepository.banThread(threadId);
    }

    public void unbanThread(long threadId) {
        threadRepository.unbanThread(threadId);
    }
}
