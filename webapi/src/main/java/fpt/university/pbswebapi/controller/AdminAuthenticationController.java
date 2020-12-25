package fpt.university.pbswebapi.controller;

import fpt.university.pbswebapi.entity.User;
import fpt.university.pbswebapi.repository.UserRepository;
import fpt.university.pbswebapi.security.services.UserDetailsImpl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/auth")
public class AdminAuthenticationController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    AuthenticationManager authenticationManager;

    @PostMapping(value = "/login")
    public String login(@RequestParam("username") String username,
                        @RequestParam("password") String password,
                        HttpSession session) {

        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(password)) {
            session.setAttribute("errorMsg", "Please provide username and passwork");
            return "admin-rework/login";
        }

        try {
            Authentication authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(username, password)
            );
            UserDetailsImpl userDetails = (UserDetailsImpl) authentication.getPrincipal();
            User user = userRepository.findById(userDetails.getId()).get();
            if(!user.getRole().getRole().toString().equalsIgnoreCase("ROLE_ADMIN")) {
                session.setAttribute("errorMsg", "Login failed");
                return "admin-rework/login";
            }
            session.setAttribute("loginUser", userDetails.getUsername());
            session.setAttribute("loginUserId", userDetails.getId());
            return "redirect:/admin/dashboard";
        } catch (Exception e) {
            session.setAttribute("errorMsg", "Login failed");
            return "admin-rework/login";
        }

    }

    @GetMapping(value = "/logout")
    public String login(HttpSession session) {
       session.removeAttribute("loginUser");
       session.removeAttribute("loginUserId");
       return "admin-rework/login";
    }
}
