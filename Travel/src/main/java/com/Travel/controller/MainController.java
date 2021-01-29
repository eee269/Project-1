package com.Travel.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.Travel.domain.StaffBean;
import com.Travel.service.StaffService;
import com.Travel.utill.ScriptUtils;
import com.mysql.cj.Session;


@Controller
public class MainController {

	@Inject
	private StaffService staffService ;

	//http://localhost:8080/go/main　　
	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public String main(HttpSession session,Model model) {
		int stf_id = (int) session.getAttribute("stf_id");
		StaffBean sb = staffService.getStaff(stf_id);
		model.addAttribute("sb",sb);		
		
//		/WEB-INF/views/main/main.jsp
		return "main/main";
	}
	
	//http://localhost:8080/go/login　　
	@RequestMapping(value = "/login", method = RequestMethod.GET)
	public String login(Model model) {
		String stf_name = "";
		String pst_id = "";
		
		HashMap map = new HashMap();
		map.put("pst_id", pst_id);
		map.put("stf_name", stf_name);
		List<StaffBean> staffList = staffService.getStaffList(map);
		model.addAttribute("staffList",staffList);		
//		/WEB-INF/views/main/login.jsp
		return "main/login";
	}
	
	//http://localhost:8080/go/loginPro　　
	@RequestMapping(value = "/loginPro", method = RequestMethod.GET)
	public String loginPro(Model model, HttpSession session ,HttpServletRequest request) {
		int u_id = Integer.parseInt(request.getParameter("u_login"));
		String u_name = request.getParameter("u_name");		
		StaffBean sb = staffService.getStaff(u_id);
		session.setAttribute("stf_id", u_id);
		session.setAttribute("stf_name", u_name);
		session.setAttribute("pst_id", sb.getPst_id());
		session.setAttribute("pst_name", sb.getPst_name());

//		/WEB-INF/views/main/login.jsp
		return "redirect:/main";
	}
	
	//http://localhost:8080/go/loginOut　　
	@RequestMapping(value = "/loginOut", method = RequestMethod.GET)
	public String loginOut(HttpSession session) {
		session.invalidate();
//		/WEB-INF/views/main/login.jsp
		return "redirect:/login";
	}
		
	//http://localhost:8080/go/header　　
	@RequestMapping(value = "/header", method = RequestMethod.GET)
	public String header(HttpSession session,HttpServletResponse response) throws Exception {
//		if((int)session.getAttribute("u_id") >= 0) {
//			ScriptUtils.alertAndMovePage(response, "로그인을 해주시길 바랍니다.","/go/login");
//		}
//		/WEB-INF/views/main/include/header.jsp
		return "include/header";
	}
	
	//http://localhost:8080/go/footer　　
	@RequestMapping(value = "/footer", method = RequestMethod.GET)
	public String footer() {
//		/WEB-INF/views/main/include/footer.jsp
		return "include/footer";
	}
	
	
	
	
}