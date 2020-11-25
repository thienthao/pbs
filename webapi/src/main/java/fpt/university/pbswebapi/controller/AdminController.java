package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.entity.ReturningType;
import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.repository.CategoryRepository;
import fpt.university.pbswebapi.repository.ReturningTypeRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import fpt.university.pbswebapi.service.ThreadService;
import fpt.university.pbswebapi.service.UserService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());

    private CategoryRepository categoryRepository;
    private ReturningTypeRepository returningTypeRepository;
    private UserRepository userRepository;
    private UserService userService;
    private ThreadService threadService;

    @Autowired
    public AdminController(CategoryRepository categoryRepository, ReturningTypeRepository returningTypeRepository, UserRepository userRepository, UserService userService, ThreadService threadService) {
        this.categoryRepository = categoryRepository;
        this.returningTypeRepository = returningTypeRepository;
        this.userRepository = userRepository;
        this.userService = userService;
        this.threadService = threadService;
    }

    @RequestMapping({"/dashboard", "/"})
    public String dashboard(Model model) {
        return "admin/dashboard";
    }

    @RequestMapping("/users/add")
    public String userAdd() {
        return "admin/user-add";
    }

    @RequestMapping("/users")
    public String userList(Model model) {
        model.addAttribute("users", userRepository.findAll());
        return "admin/user-list";
    }

    @GetMapping(value = {"/users/{userId}/edit"})
    public String showEditUserPage(Model model, @PathVariable long userId) {
        User user = null;
        try {
            user = userRepository.findById(userId).get();
        } catch (Exception e) {
            model.addAttribute("errorMessage", "User Not Found");
        }
        model.addAttribute("add", false);
        model.addAttribute("user", user);
        return "admin/user-edit";
    }

    @PostMapping(value = {"/users/{userId}/block"})
    public String blockUser(
            Model model, @PathVariable long userId) {
        try {
            userService.blockUser(userId);
            String uri = "admin/users/" + userId + "/edit";
            model.addAttribute("errorMessage", "Blocked");
            return "redirect:/" + uri;
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            logger.error(errorMessage);
            model.addAttribute("errorMessage", errorMessage);
            return "/admin/user-edit";
        }
    }

    @PostMapping(value = {"/users/{userId}/unblock"})
    public String unblockUser(
            Model model, @PathVariable long userId) {
        try {
            userService.unblockUser(userId);
            String uri = "admin/users/" + userId + "/edit";
            model.addAttribute("errorMessage", "Blocked");
            return "redirect:/" + uri;
        } catch (Exception ex) {
            String errorMessage = ex.getMessage();
            logger.error(errorMessage);
            model.addAttribute("errorMessage", errorMessage);
            return "/admin/user-edit";
        }
    }

    @RequestMapping("/returningTypes")
    public String returningTypeList(Model model) {
        model.addAttribute("returningTypes", returningTypeRepository.findAll());
        return "admin/returning-type";
    }

    @GetMapping(value = {"/returningTypes/{returningTypeId}/edit"})
    public String showReturningTypePage(Model model, @PathVariable int returningTypeId) {
        ReturningType returningType = null;
        try {
            returningType = returningTypeRepository.findById(returningTypeId);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Resource Not Found");
        }
        model.addAttribute("add", false);
        model.addAttribute("returningType", returningType);
        return "admin/returning-type-edit";
    }

    @RequestMapping("/categories")
    public String categoriesList(Model model) {
        model.addAttribute("categories", categoryRepository.findAll());
        return "admin/category-list";
    }

    @RequestMapping("/categories/add")
    public String categoriesAdd(Model model) {
        model.addAttribute("categories", categoryRepository.findAll());
        return "admin/category-add";
    }

    @GetMapping("/threads")
    public String showThreadsPage(Model model) {
        model.addAttribute("threads", threadService.all());
        return "admin/thread-list";
    }

    @GetMapping("/threads/topics")
    public String showThreadTopicsPage(Model model) {
        model.addAttribute("topics", threadService.allTopics());
        return "admin/topic-list";
    }
}
