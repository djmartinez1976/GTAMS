package com.github.djm.controller;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.github.djm.util.DbUtil;
import com.github.djm.util.emailUtil;


/**
 * Servlet implementation class NominatorActionController
 */

@SuppressWarnings("serial")
public class NominatorActionController extends HttpServlet {
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public NominatorActionController() {
		super();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 *      
	 *      This method will 
	 *      1. insert the record in nominee table
	 *      2. send email to the nominee. 
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
							throws ServletException, IOException 
	{
		request.setAttribute("successMessage", "");
		request.setAttribute("errorMessage", "");
		
		NomineeDetailsByNominator nomineeDetails = new NomineeDetailsByNominator(request);
		String result = nomineeDetails.validateDetails();
		if (result.isEmpty())
		{
			if (nomineeDetails.insertIntoDB())
			{
				request.setAttribute("successMessage", "Record Inserted In DB");
				nomineeDetails.alertNomineeViaEmail();
			}
			else
			{
				request.setAttribute("errorMessage", "Unable to Insert Record In DB");
			}
		}
		else
		{
			request.setAttribute("errorMessage", result);
		}
		request.getRequestDispatcher("/content/nominator_view.jsp").forward(request, response);
	}
}

class NomineeDetailsByNominator{

	public String nomineeName;
	public String nomineeEmail;
	public String ranking;
	public String pid;
	public String isPHDCS;
	public String newPHD;
	public String nominatedBy;
	public String nominatedAt;
	
	public NomineeDetailsByNominator(HttpServletRequest request) {
		nomineeName = request.getParameter("nomineeName");
		nomineeEmail = request.getParameter("nomineeEmail");
		ranking = request.getParameter("ranking");
		pid = request.getParameter("pid");
		isPHDCS = request.getParameter("isPHDCS");
		newPHD = request.getParameter("newPHD");
		nominatedBy = request.getSession().getAttribute("name").toString();
		
		String pattern = "yyyy-MM-dd";
		nominatedAt =new SimpleDateFormat(pattern).format(new Date());
	}
	
	public String validateDetails()
	{
		String result="";
		return result;
	}
	
	public boolean insertIntoDB()
	{
		java.sql.Connection dbConnection = DbUtil.getConnection();
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("insert into nominee (name, email, pid, nominated_by, ranking, is_phd_cs, is_new, nominated_at) values (?, ?, ?, ?, ?, ?, ?, ?)");
			prepStatement.setString(1, nomineeName);
			prepStatement.setString(2, nomineeEmail);
			prepStatement.setString(3, pid);
			prepStatement.setString(4, nominatedBy);
			prepStatement.setInt(5, Integer.parseInt(ranking));
			prepStatement.setString(6, isPHDCS.substring(0,1));
			prepStatement.setString(7, newPHD.substring(0,1));
			prepStatement.setString(8, nominatedAt);
			prepStatement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public boolean alertNomineeViaEmail()
	{		
		boolean result=true;
		String defPasswd = "gtams@123";
		java.sql.Connection dbConnection = DbUtil.getConnection();
		try {
			//insert into login_master values ('sysadm', 'sysadm', 'N', 'S', '', 'sysadm');
			PreparedStatement prepStatement = dbConnection.prepareStatement("insert into login_master (userName, password, pwd_expired, role, pwd_recovery_key, name) values (?, ?, 'N', 'N', '', ?)");
			
			prepStatement.setString(1, nomineeEmail);
			prepStatement.setString(2, defPasswd);
			prepStatement.setString(3, nomineeName);
			prepStatement.execute();
			
			String email = nomineeEmail;
			String subject = "Nomination for GTA";
			String body = "Congratulations " + nomineeName 
						+ "! \nYou have been nominated by " + nominatedBy + "\n" 
						+ "Please provide the complete information using following login credentials" 
						+ "login:" + nomineeEmail + "\npassword:" + defPasswd
						+ "\n\nThanks,\nGTAMS\n\nThis is Automated Email genereated by GTAMS" ;
			
			emailUtil.sendEmail(email, subject, body);
		} catch (SQLException e) {
			e.printStackTrace();
			result= false;
		}
		return result;
	}
}