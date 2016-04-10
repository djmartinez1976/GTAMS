package com.github.djm.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import com.github.djm.model.LoginInfo;
import com.github.djm.util.DbUtil;

public class StudentRepository {
	private Connection dbConnection;
	
	public StudentRepository() {
		dbConnection = DbUtil.getConnection();
	}
	
	public void save(String userName, String password, String firstName, String lastName, String dateOfBirth, String emailAddress) {
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("insert into student(userName, password, firstName, lastName, dateOfBirth, emailAddress) values (?, ?, ?, ?, ?, ?)");
			
			prepStatement.setString(1, userName);
			prepStatement.setString(2, password);
			prepStatement.setString(3, firstName);
			prepStatement.setString(4, lastName);
			prepStatement.setDate(5, new java.sql.Date(new SimpleDateFormat("MM/dd/yyyy")
			.parse(dateOfBirth.substring(0, 10)).getTime()));
			prepStatement.setString(6, emailAddress);
			
			prepStatement.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ParseException e) {			
			e.printStackTrace();
		}
	}
	
	public boolean findByUserName(String userName) {
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("select count(*) from student where userName = ?");
			prepStatement.setString(1, userName);	
						
			ResultSet result = prepStatement.executeQuery();
			if (result != null) {	
				while (result.next()) {
					if (result.getInt(1) == 1) {
						return true;
					}				
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean findByLogin(String userName, String password) {
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("select password from login_master where username = ?");
			prepStatement.setString(1, userName);			
			
			ResultSet result = prepStatement.executeQuery();
			if (result != null) {
				while (result.next()) {
					if (result.getString(1).equals(password)) {
						return true;
					}
				}				
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	
	/**
	 * 
	 * 
	 * @param userName
	 * @param password
	 * @return X if no user was found, else the role defined
	 */
	public String findRoleByLogin(String userName, String password) {
		String result = "X";
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("select password,role from login_master where username = ?");
			prepStatement.setString(1, userName);			
			
			ResultSet rs = prepStatement.executeQuery();
			if (result != null) {
				while (rs.next()) {
					if (rs.getString("password").equals(password)) {
						result = rs.getString("role");
						return result;
					}
				}				
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 
	 * 
	 * @param userName
	 * @param password
	 * @return X if no user was found, else the role defined
	 */
	public LoginInfo getLoginInfoByLogin(String userName, String password) {
		LoginInfo result = new LoginInfo();
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("select password,role,name,pwd_recovery_key from login_master where username = ?");
			prepStatement.setString(1, userName);			
			
			ResultSet rs = prepStatement.executeQuery();
			if (rs != null) {
				while (rs.next()) {
					if (rs.getString("password").equals(password)) {
						result.Role = rs.getString("role");
						result.name = rs.getString("name");
						result.key = rs.getString("pwd_recovery_key");
						return result;
					}
				}				
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

}
