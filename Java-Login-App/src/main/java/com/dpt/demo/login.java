package com.dpt.demo;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.dpt.demo.model.UserInfo;
import com.dpt.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class login {

	@Autowired
	private UserService userService;

	@GetMapping("/login")
	public ModelAndView loginPage(HttpSession session) {
		if (session.getAttribute("currentUser") != null) {
			if ("ROLE_ADMIN".equals(session.getAttribute("role"))) {
				return new ModelAndView("redirect:/admin");
			}
			ModelAndView mv = new ModelAndView("user");
			mv.addObject("username", session.getAttribute("currentUser"));
			mv.addObject("role", session.getAttribute("role"));
			return mv;
		}
		return new ModelAndView("login");
	}

	@GetMapping("/user")
	public ModelAndView userPage(HttpSession session) {
		if (session.getAttribute("currentUser") == null) {
			return new ModelAndView("redirect:/login");
		}
		ModelAndView mv = new ModelAndView("user");
		mv.addObject("username", session.getAttribute("currentUser"));
		mv.addObject("role", session.getAttribute("role"));
		return mv;
	}

	@PostMapping("/login")
	public ModelAndView handleLogin(
			@RequestParam(value = "userName", required = false) String userName,
			@RequestParam(value = "password", required = false) String password,
			HttpServletRequest request,
			HttpSession session) {

		String clientIp = request.getHeader("X-Forwarded-For");
		if (clientIp == null || clientIp.isEmpty() || "unknown".equalsIgnoreCase(clientIp)) {
			clientIp = request.getRemoteAddr();
		} else if (clientIp.contains(",")) {
			clientIp = clientIp.split(",")[0].trim();
		}
		String userAgent = request.getHeader("User-Agent");

		UserInfo authenticatedUser = userService.authenticate(userName, password, clientIp, userAgent);

		if (authenticatedUser != null) {
			session.setAttribute("currentUser", authenticatedUser.getUsername());
			session.setAttribute("role", authenticatedUser.getRole());
			session.setAttribute("fullName", authenticatedUser.getFirstName() + " " + authenticatedUser.getLastName());

			if (authenticatedUser.isAdmin()) {
				return new ModelAndView("redirect:/admin");
			}

			ModelAndView mv = new ModelAndView("user");
			mv.addObject("username", authenticatedUser.getUsername());
			mv.addObject("role", authenticatedUser.getRole());
			return mv;
		} else {
			ModelAndView mv = new ModelAndView("login");
			mv.addObject("errorMessage", "Invalid Username or Password. Please try again.");
			return mv;
		}
	}

	@GetMapping("/logout")
	public String handleLogout(HttpSession session) {
		session.invalidate();
		return "redirect:/login";
	}

	@PostMapping("/api/heartbeat")
	@ResponseBody
	public String heartbeat(HttpSession session) {
		String username = (String) session.getAttribute("currentUser");
		if (username != null) {
			userService.updateHeartbeat(username);
			return "OK";
		}
		return "NO_SESSION";
	}
}
