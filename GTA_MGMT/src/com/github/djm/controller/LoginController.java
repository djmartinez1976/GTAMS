package com.github.djm.controller;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.github.djm.model.LoginInfo;
import com.github.djm.repository.StudentRepository;

/**
 * Servlet implementation class LoginController
 */

@SuppressWarnings("serial")
public class LoginController extends HttpServlet {
	private StudentRepository studentRepository;

	private static String NomineePage = "content/nominee_view.jsp";
	private static String NominatorPage = "content/nominator_view.jsp";
	private static String GCPage = "content/gc_members_view.jsp";
	private static String SysAdmPage = "content/sysAdmin_view.jsp";
	private static String LOGIN_FAILURE = "content/failure.jsp";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public LoginController() {
		super();
		studentRepository = new StudentRepository();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {	
		String forward = SysAdmPage;
		RequestDispatcher view = request.getRequestDispatcher(forward);
		view.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		String pageName = request.getParameter("pageName");
		String forward = "";		
		
		if (studentRepository != null) {
			if (pageName.equals("login")) {
				LoginInfo result = studentRepository.getLoginInfoByLogin(
						request.getParameter("userName"),
						request.getParameter("password"));
				if (result.Role.equalsIgnoreCase("X")) {
					forward = LOGIN_FAILURE;
				} else if (result.Role.equalsIgnoreCase("N")) {
					System.out.println("Login successful, Redirecting to N");
					forward = NomineePage;
				} else if (result.Role.equalsIgnoreCase("F")) {
					forward = NominatorPage;
					System.out.println("Login successful, Redirecting to F");
				} else if (result.Role.equalsIgnoreCase("G")) {
					forward = GCPage;
					System.out.println("Login successful, Redirecting to G");
				} else if (result.Role.equalsIgnoreCase("S")) {
					forward = SysAdmPage;
					System.out.println("Login successful, Redirecting to S");
				} 
				request.getSession().setAttribute("Role", result.Role);
				request.getSession().setAttribute("name", result.name);
				
			}
		}
		RequestDispatcher view = request.getRequestDispatcher(forward);
		view.forward(request, response);
	}
}
