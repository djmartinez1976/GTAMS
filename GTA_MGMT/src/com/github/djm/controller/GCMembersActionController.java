package com.github.djm.controller;

import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
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
 * Servlet implementation class NomineeActionController
 */

@SuppressWarnings("serial")
public class GCMembersActionController extends HttpServlet {
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public GCMembersActionController() {
		super();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 *      
	 *      This method will 
	 *      2. send email to the nominee. 
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
							throws ServletException, IOException 
	{
		request.setAttribute("successMessage", "");
		request.setAttribute("errorMessage", "");
		
		NomineeScoreByGC nomineeDetails = new NomineeScoreByGC(request);
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

class NomineeScoreByGC{

	public String GCMember;
	
	public ArrayList<String> nomineeNames;
	public ArrayList<String> nomineeComments;
	public ArrayList<Integer> scores;
	public int count;
	
	public NomineeScoreByGC(HttpServletRequest request) {
		GCMember = request.getSession().getAttribute("name").toString();
		nomineeNames = new ArrayList<String>();
		nomineeComments = new ArrayList<String>();
		scores = new ArrayList<Integer>();
		// Get all the nominees from nominee table and search for gc_nominee from the request and insert it into the db
		try{
			java.sql.Connection dbConnection = DbUtil.getConnection();
	        Statement stmtNominee = dbConnection.createStatement();
	        ResultSet rsNominee = stmtNominee.executeQuery("select name from nominee") ;
	        
	        String currScoreTextBox, currCommentTextBox;
	        count=0;
	        while (rsNominee.next())
	        {
	        	currScoreTextBox = GCMember + "_" + rsNominee.getString("name") + "_score" ;
	        	currCommentTextBox = GCMember + "_" + rsNominee.getString("name") + "_comment" ;
	        	nomineeNames.add(rsNominee.getString("name"));
	        	scores.add(new Integer(request.getParameter(currCommentTextBox)));
	        	count++;
	        }
		}catch (SQLException e)
		{
			e.printStackTrace();
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
		try {
			Statement presenceChkStmt = dbConnection.createStatement();
			PreparedStatement insStatement, updtStatement;
			
			for (int i=0; i<count; i++)
			{
				ResultSet rsCheck = presenceChkStmt.executeQuery("select * from scorecard where gcm_name='" + GCMember + "' and nominee_name='" + nomineeNames.get(i) + "'");
				if (rsCheck.next())
				{
					updtStatement = dbConnection.prepareStatement("update table scorecard set score = ?, comment = ? where gcm_name= ? and nominee_name = ?");
					updtStatement.setInt(1, scores.get(i).intValue());
					updtStatement.setString(2, nomineeComments.get(i));
					updtStatement.setString(3, GCMember);
					updtStatement.setString(4, nomineeNames.get(i));
					updtStatement.execute();
				}
				else
				{
					
					insStatement = dbConnection.prepareStatement("insert into scorecard (nominee_name, gcm_name, score, comment) values (?, ?, ?, ?)");
					insStatement.setString(1, GCMember);
					insStatement.setString(2, nomineeNames.get(i));
					insStatement.setInt(3, scores.get(i).intValue());
					insStatement.setString(4, nomineeComments.get(i));
					insStatement.execute();
				}
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
		return result;
	}
}