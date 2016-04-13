package com.github.djm.controller;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.github.djm.util.DbUtil;
import com.github.djm.util.emailUtil;

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


/**
 * Servlet implementation class SysAdminActionController
 */

@SuppressWarnings("serial")
public class SysAdminActionController extends HttpServlet {
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public SysAdminActionController() {
		super();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 *      
	 *      This method will 
	 *      1. insert the record in session_master table
	 *      2. Insert records in login_master table.
	 *      3. Insert records in gc_members table.
	 *      4. Send email to the gc_members 
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
							throws ServletException, IOException 
	{
		request.setAttribute("successMessage", "");
		request.setAttribute("errorMessage", "");
		
		NomineeDetailsByNominee nomineeDetails = new NomineeDetailsByNominee(request);
		String result = nomineeDetails.validateDetails();
		if (result.isEmpty())
		{
			if (nomineeDetails.insertIntoDB())
			{
				request.setAttribute("successMessage", "Record Updated");
				nomineeDetails.alertNominatorViaEmail();
			}
			else
			{
				request.setAttribute("errorMessage", "Unable to Update Record");
			}
		}
		else
		{
			request.setAttribute("errorMessage", result);
		}
		request.getRequestDispatcher("/content/nominee_view.jsp").forward(request, response);
	}
}

class GCMembersDetailsBySysAdmin{
	public String sessionID;
	public String gcChair;
	public ArrayList<String> gcMemberNames;
	public ArrayList<String> gcMemberEmails;
	public ArrayList<String> gcMemberUserNames;
	public ArrayList<String> gcMemberPasswords;
	public String deadLineNominee;
	public String deadLineNominator;
	public String deadLineVerification;
	
	
	public GCMembersDetailsBySysAdmin(HttpServletRequest request) {
		sessionID = request.getParameter("sessionId");
		gcChair = request.getParameter("gcChair");
		deadLineNominator = request.getParameter("deadLineNominator");
		deadLineNominee = request.getParameter("deadLineNominee");
		deadLineVerification = request.getParameter("deadLineVerification");
		
		for (int i=1; i<=10; i++)
		{
			String name = request.getParameter("gcMemberName" + i);
			if (name == null  || name.length() <1)
				break;
			
			gcMemberNames.add(request.getParameter("gcMemberName" + i));
			gcMemberNames.add(request.getParameter("gcMemberEmail" + i));
			gcMemberNames.add(request.getParameter("gcMemberUserName" + i));
			gcMemberNames.add(request.getParameter("gcMemberPassword" + i));
		}
		
	}
	
	public String validateDetails()
	{
		String result="";
		return result;
	}
	
	public boolean insertIntoDB()
	{
		java.sql.Connection dbConnection = DbUtil.getConnection();
		// Insert into session_master
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("insert into session_master(session_id, faculty_deadline, nominee_deadline, gc_deadline,  gc_chair) values (?, ?, ?, ?, ?);");
			prepStatement.setString(1, sessionID);
			
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	        try{
			prepStatement.setDate(2, new java.sql.Date(format.parse(deadLineNominator).getTime()));
			prepStatement.setDate(3, new java.sql.Date(format.parse(deadLineNominee).getTime()));
			prepStatement.setDate(4, new java.sql.Date(format.parse(deadLineVerification).getTime()));
	        } catch (ParseException e)
	        {
	        	e.printStackTrace();
	        	return false;
	        }
			prepStatement.setString(5, gcChair);
			prepStatement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		
		// Insert GC Members Records
		try {
			for (int i=0; i<gcMemberNames.size(); i++)
			{
				PreparedStatement prepStatement = dbConnection.prepareStatement("insert into gc_members(name, email, session_id) values (?,?,?);");
				prepStatement.setString(1, gcMemberNames.get(i));
				prepStatement.setString(2, gcMemberEmails.get(i));
				prepStatement.setString(3, sessionID);
				prepStatement.execute();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	
		// Insert login_master Records
		try {
			for (int i=0; i<gcMemberNames.size(); i++)
			{
				PreparedStatement prepStatement = dbConnection.prepareStatement("insert into login_master values (?, ?, 'N', 'G', '', ?);");
				prepStatement.setString(1, gcMemberUserNames.get(i));
				prepStatement.setString(2, gcMemberPasswords.get(i));
				prepStatement.setString(3, gcMemberNames.get(i));
				prepStatement.execute();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public boolean alertNominatorViaEmail()
	{
		boolean result=true;

		for (int i=0; i<gcMemberNames.size(); i++)
		{
			String email = gcMemberEmails.get(i);
			String subject = "Appointed as GC Member for "+sessionID + " session";
			String body = "Congratulations" + gcMemberNames.get(i) + "!! \n You have been appointed as a GC Member.\n\n" +
					"You can Login to the GTAMS using following credentials\n\nLogin:"+ 
					gcMemberUserNames.get(i) + "\nPassword:  " + gcMemberPasswords.get(i) ;
			
			
			emailUtil.sendEmail(email, subject, body);
		}

		return result;
	}
}