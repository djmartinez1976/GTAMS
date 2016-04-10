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

import java.util.Properties;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;


/**
 * Servlet implementation class NomineeActionController
 */

@SuppressWarnings("serial")
public class NomineeActionController extends HttpServlet {
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public NomineeActionController() {
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

class NomineeDetailsByNominee{

	public String name;
	public String registeredAt;
	public String nominatedBy;
	
	// Information to be updated in nominee table
	public String phoneNo;
	public String isPHDCS;
	public String isSpeakTestPassed;
	public String numGradSem;
	public String numSemGTA;
	public String currPHDA;
	public String GPA;
	
	// Information to be updated in PHDA table
	public int numPrevPHDA;
	public String[] prevPHDA;
	public int[] prevPHDDuration;
	
	// Information to be updated in GLC table
	public int numCourse;
	public String[] courseNames;
	public String[] courseGrade;
	
	// Information to be updated in Publication table
	public int numPub;
	public String[] pubNames;
	public String[] pubComment;
	
	public NomineeDetailsByNominee(HttpServletRequest request) {
		name = request.getParameter("nomineeName");
		phoneNo = request.getParameter("phoneNo");
		isPHDCS = request.getParameter("isPHDCS");
		isSpeakTestPassed = request.getParameter("speakTestPassed");
		numGradSem = request.getParameter("numSemesters");
		numSemGTA = request.getParameter("numSemestersGTA");
		currPHDA = request.getParameter("currentPHDAdvisor");
		GPA = request.getParameter("GPA");
		nominatedBy = request.getParameter("nominatedBy");
		
		String pattern = "yyyy-MM-dd";
		registeredAt =new SimpleDateFormat(pattern).format(new Date());
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
			PreparedStatement prepStatement = dbConnection.prepareStatement("update nominee set phone=?, current_phd_advisor=?, is_phd_cs=?, numSemGrad=?, speaktestPassed=?, numSemGTA=?, isRegistered='Y', registered_at=? where name='" + name+"'");
			prepStatement.setString(1, phoneNo);
			prepStatement.setString(2, currPHDA);
			prepStatement.setString(3, isPHDCS.substring(0,1));
			prepStatement.setInt(4, Integer.parseInt(numGradSem));
			prepStatement.setString(5, isSpeakTestPassed.substring(0,1));
			prepStatement.setInt(6, Integer.parseInt(numSemGTA));
			prepStatement.setString(7, registeredAt);
			prepStatement.execute();
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
	
	public boolean alertNominatorViaEmail()
	{
		boolean result=true;
		
		java.sql.Connection dbConnection = DbUtil.getConnection();
		try {
			Statement stmtNominator = dbConnection.createStatement();
			ResultSet rsNominator = stmtNominator.executeQuery("select * from nominee where name='" + nominatedBy +"'") ;
			
			if (rsNominator.next())
			{
				String email = rsNominator.getString("email");
				String subject = "Nominated student : " + name + " registered";
				String body = "Student : " + name + " completed the registration" + "\n" + "Please verify the details" + "\n\nThanks,\nGTAMS\n\nThis is Automated Email genereated by GTAMS" ;
				emailUtil.sendEmail(email, subject, body);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}

//		
//		Properties props = new Properties();
//		props.put("mail.smtp.host", "smtp.gmail.com");
//		props.put("mail.smtp.socketFactory.port", "465");
//		props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
//		props.put("mail.smtp.auth", "true");
//		props.put("mail.smtp.port", "465");
//
//		Session session = Session.getDefaultInstance(props,
//			new javax.mail.Authenticator() {
//				protected PasswordAuthentication getPasswordAuthentication() {
//					return new PasswordAuthentication("gtamstest@gmail.com","gtams@123");
//				}
//			});
//
//		try {
//
//			Message message = new MimeMessage(session);
//			message.setFrom(new InternetAddress("gtamstest@gmail.com"));
//			message.setRecipients(Message.RecipientType.TO, InternetAddress.parse("tushar.agarwal053@gmail.com"));
//			message.setSubject("Nominee registered:");
//			message.setText("Dear Mail Crawler," + "\n\n No spam to my email, please!");
//
//			Transport.send(message);
//
//			System.out.println("Done");
//
//		} catch (MessagingException e) {
//			throw new RuntimeException(e);
//		}
		return result;
	}
}