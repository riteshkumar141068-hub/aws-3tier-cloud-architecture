package com.ritesh.grizzlyops;

import com.ritesh.grizzlyops.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class register {

	@Autowired
	private UserService userService;

	@GetMapping("/register")
	public ModelAndView registerForm() {
		return new ModelAndView("register");
	}

	@PostMapping("/register")
	public ModelAndView handleRegistration(
			@RequestParam(value = "firstName", required = false) String firstName,
			@RequestParam(value = "lastName", required = false) String lastName,
			@RequestParam(value = "email", required = false) String email,
			@RequestParam(value = "userName", required = false) String userName,
			@RequestParam(value = "password", required = false) String password) {

		ModelAndView mv = new ModelAndView("register");

		if (userName == null || userName.trim().isEmpty() || password == null || password.trim().isEmpty()) {
			mv.addObject("message", "Registration failed: Username and Password are required.");
			return mv;
		}

		boolean success = userService.registerUser(firstName, lastName, email, userName, password);

		if (success) {
			mv.addObject("message", "User account has been added successfully for " + userName);
		} else {
			mv.addObject("message", "Registration failed! Username or Email might already be taken.");
		}

		return mv;
	}
}

