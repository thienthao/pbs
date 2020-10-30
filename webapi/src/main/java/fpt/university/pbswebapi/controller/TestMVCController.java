package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.dto.UserForm;
import fpt.university.pbswebapi.entity.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import java.util.ArrayList;
import java.util.List;

@Controller
public class TestMVCController {
    private static List<User> users = new ArrayList<>();

    static {
        User user1 = new User();
        user1.setFullname("Thien Thao");
        user1.setUsername("thienthao");
        User user2 = new User();
        user2.setFullname("Bao Xuan");
        user2.setUsername("baoxuan");
        users.add(user1);
        users.add(user2);
    }

    private String message = "Hello Thymeleaf";
    private String errorMessage = "First name and username is required";

    @RequestMapping(value = {"/admin/", "/admin/index"}, method = RequestMethod.GET)
    public String index(Model model) {
        model.addAttribute("message", message);
        return "index";
    }

    @RequestMapping(value = {"/admin/userList"}, method = RequestMethod.GET)
    public String userList(Model model) {
        model.addAttribute("users", users);
        return "userList";
    }

    @RequestMapping(value = {"/admin/addUser"}, method = RequestMethod.GET)
    public String showAddUserPage(Model model) {
        UserForm userForm = new UserForm();
        model.addAttribute("userForm", userForm);
        return "addUser";
    }

    @RequestMapping(value = {"/admin/addUser"}, method = RequestMethod.POST)
    public String saveUser(Model model,
                           @ModelAttribute("userForm") UserForm userForm) {
        String fullName = userForm.getFullName();
        String username = userForm.getUsername();

        if(fullName != null && fullName.length() >0 && username != null && username.length() > 0) {
            User user = new User();
            user.setFullname(fullName);
            user.setUsername(username);
            users.add(user);

            return "redirect:/admin/userList";
        }
        model.addAttribute("errorMessage", errorMessage);
        return "addUser";
    }
}
