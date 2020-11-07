package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.Thread;
import fpt.university.pbswebapi.repository.ThreadRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ThreadService {
    private final ThreadRepository threadRepository;

    @Autowired
    public ThreadService(ThreadRepository threadRepository) {
        this.threadRepository = threadRepository;
    }

    public List<Thread> all() {
        return threadRepository.findAll();
    }
}
