package com.dpt.demo;

import javax.servlet.http.HttpSession;

import com.dpt.demo.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class login {

	@Autowired
	private UserService userService;

	@GetMapping("/login")
	public ModelAndView loginPage() {
		return new ModelAndView("login");
	}

	@PostMapping("/login")
	public ModelAndView handleLogin(
			@RequestParam(value = "userName", required = false) String userName,
			@RequestParam(value = "password", required = false) String password,
			HttpSession session) {

		String authenticatedUser = userService.authenticate(userName, password);

		if (authenticatedUser != null) {
			session.setAttribute("currentUser", authenticatedUser);
			ModelAndView mv = new ModelAndView("user");
			mv.addObject("username", authenticatedUser);
			return mv;
		} else {
			ModelAndView mv = new ModelAndView("login");
			mv.addObject("errorMessage", "Invalid Username or Password. Please try again.");
			return mv;
		}
	}
}
