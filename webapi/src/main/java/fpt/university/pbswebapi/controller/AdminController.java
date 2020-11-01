package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.repository.CategoryRepository;
import fpt.university.pbswebapi.repository.ReturningTypeRepository;
import fpt.university.pbswebapi.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminController {
    private CategoryRepository categoryRepository;
    private ReturningTypeRepository returningTypeRepository;
    private UserRepository userRepository;

    @Autowired
    public AdminController(CategoryRepository categoryRepository, ReturningTypeRepository returningTypeRepository, UserRepository userRepository) {
        this.categoryRepository = categoryRepository;
        this.returningTypeRepository = returningTypeRepository;
        this.userRepository = userRepository;
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

    @RequestMapping("/returningTypes")
    public String returningTypeList(Model model) {
        model.addAttribute("returningTypes", returningTypeRepository.findAll());
        return "admin/returning-type";
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
}
