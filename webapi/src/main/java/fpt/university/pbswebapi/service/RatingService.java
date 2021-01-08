package fpt.university.pbswebapi.service;

import fpt.university.pbswebapi.entity.BookingComment;
import fpt.university.pbswebapi.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

@Service
public class RatingService {

    private CommentRepository commentRepository;

    @Autowired
    public RatingService(CommentRepository commentRepository) {
        this.commentRepository = commentRepository;
    }

    public Page<BookingComment> getAll(Pageable pageable) {
        return commentRepository.findAll(pageable);
    }
}
