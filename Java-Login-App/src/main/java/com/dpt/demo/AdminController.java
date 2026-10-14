package com.dpt.demo;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpSession;

import com.dpt.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class AdminController {

    @Autowired
    private UserService userService;

    @GetMapping("/admin")
    public ModelAndView adminDashboard(HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (role == null || !"ROLE_ADMIN".equalsIgnoreCase(role)) {
            return new ModelAndView("redirect:/login");
        }

        ModelAndView mv = new ModelAndView("admin");
        mv.addObject("username", session.getAttribute("currentUser"));
        mv.addObject("metrics", userService.getSystemMetrics());
        mv.addObject("auditLogs", userService.getRecentAuditLogs(50));
        mv.addObject("usersList", userService.getAllUsers());
        return mv;
    }

    @PostMapping("/admin/delete-user")
    public String deleteUser(@RequestParam("id") int id, HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (role != null && "ROLE_ADMIN".equalsIgnoreCase(role)) {
            userService.deleteUser(id);
        }
        return "redirect:/admin";
    }

    @GetMapping("/admin/api/telemetry")
    @ResponseBody
    public Map<String, Object> liveTelemetry(HttpSession session) {
        String role = (String) session.getAttribute("role");
        if (role != null && "ROLE_ADMIN".equalsIgnoreCase(role)) {
            return userService.getSystemMetrics();
        }
        return Map.of("error", "UNAUTHORIZED");
    }
}
