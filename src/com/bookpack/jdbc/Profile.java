package com.bookpack.jdbc;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Profile {
	static Scanner stdin = new Scanner(System.in);
	private static Profile profile = new Profile( );
	
	public static Profile getInstance( ) {
		return profile;
	}
	public void display_student(Login login)
	{
		System.out.println("Display student detail");
		System.out.println("----------------------------------");
		
		String sql = "select * from athoma12.view_profile where username = ?";
		PreparedStatement cstmt=null;
		ResultSet rs = null;
		
		try {
			cstmt = DBConnection.conn.prepareStatement(sql);
			cstmt.setString(1, login.user_name);

			rs = cstmt.executeQuery();
			
			while(rs.next())
			{
				String first_name = rs.getString("FIRST_NAME");
				String last_name = rs.getString("LAST_NAME");
				Date dob = rs.getDate("DATE_OF_BIRTH");
				String dept = rs.getString("DEPARTMENT");
				String nationality = rs.getString("NATIONALITY");
				String sex = rs.getString("SEX");
				if(sex == "M")
				{
					sex = "Male";
				}
				else if(sex == "F")
				{
					sex = "Female";
				}
				//String patron_type = rs.getString("PATRON_TYPE");
				String address1 = rs.getString("ADDRESS_LINE_1");
				String address2 = rs.getString("ADDRESS_LINE_2");
				String address3 = rs.getString("ADDRESS_LINE_3");
				String city = rs.getString("CITY");
				String state = rs.getString("STATE");
				String country = rs.getString("COUNTRY");
				String ph_no = rs.getString("PHONE_NUMBER");
				String alt_ph_no = rs.getString("ALT_PHONE_NUMBER");
				String degree_pgm = rs.getString("DEGREE_PROGRAM");
				String st_cat = rs.getString("ST_CATEGORY");
				String st_class = rs.getString("ST_CLASSIFICATION");
				
				System.out.println("Student Name: ");
				System.out.println(first_name);
				System.out.println(last_name);
				System.out.println("Date of birth: ");
				System.out.println(dob);
				System.out.println("Department: ");
				System.out.println(dept);
				System.out.println("Nationality: ");
				System.out.println(nationality);
				System.out.println("Sex: ");
				System.out.println(sex);
				//System.out.println(patron_type);
				System.out.println("Address: ");
				System.out.println(address1);
				System.out.println(address2);
				System.out.println(address3);
				System.out.println("City: ");
				System.out.println(city);
				System.out.println("State: ");
				System.out.println(state);
				System.out.println("Country: ");
				System.out.println(country);
				System.out.println("Phone Number: ");
				System.out.println(ph_no);
				System.out.println("Alternate phone numebr: ");
				System.out.println(alt_ph_no);
				System.out.println("Degree Program: ");
				System.out.println(degree_pgm);
				System.out.println("Student Category: ");
				System.out.println(st_cat);
				System.out.println("Student Classification: ");
				System.out.println(st_class);
				

			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		} finally {
			if(cstmt != null)
			{
				try{cstmt.close();}
				catch(SQLException e){
				}
			}
		}
		
		System.out.println("<Menu>");	
		System.out.println("1. To edit the fields");
		System.out.println("2. GO back");
		System.out.print("Enter your Choice >> ");
		
		int func = stdin.nextInt();
		stdin.nextLine();
		switch (func) {
		case 1:
			
			break;
		case 2:
			
			break;
		default:
			System.out.println("Wrong input. Try again!");
		}
	}

}
