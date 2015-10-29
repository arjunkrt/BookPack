package com.bookpack.jdbc;

import java.sql.CallableStatement;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Scanner;

public class Profile {

	String address1 = "";
	String address2 = "";
	String address3 = "";
	String ph_no = "";
	String alt_ph_no = "";

	static Scanner stdin = new Scanner(System.in);
	private static Profile profile = new Profile( );

	public static Profile getInstance( ) {
		return profile;
	}

	public void update_profile(Login login)
	{
		String sql = "{call athoma12.patrons_mgmt.updateProfile(?,?,?,?,?,?,?)}";
		CallableStatement cstmt=null;

		try {
			cstmt = DBConnection.conn.prepareCall(sql);

			cstmt.setString(1,login.user_name);
			cstmt.setString(2,login.user_password);
			cstmt.setString(3,address1);
			cstmt.setString(4,address2);
			cstmt.setString(5,address3);
			cstmt.setString(6,ph_no);
			cstmt.setString(7,alt_ph_no);

			cstmt.execute();

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
	}

	public void edit_profile(Login login)
	{
		System.out.println("Edit student detail");
		System.out.println("----------------------------------");
		System.out.println("Following fields can be edited");

		System.out.print("1. User Password: ");
		System.out.println(login.user_password);
		/*
		 * If the logged in user is a student
		*/
		if(login.user_type.equals("S"))
		{
			System.out.println("Address: ");
			System.out.print("2. Line 1: ");
			System.out.println(address1);
			System.out.print("3. Line 2: ");
			System.out.println(address2);
			System.out.print("4. Line 3: ");
			System.out.println(address3);
			System.out.print("5. Phone Number: ");
			System.out.println(ph_no);
			System.out.print("6. Alternate phone numebr: ");
			System.out.println(alt_ph_no);
		}

		int func;
		if(login.user_type.equals("S"))
		{
			do
			{
				System.out.println("<Menu>");	
				System.out.println("1. To Enter new User Password ");
				System.out.println("2. To Enter new Address Line 1 ");
				System.out.println("3. To Enter new Address Line 2 ");
				System.out.println("4. To Enter new Address Line 3 ");
				System.out.println("5. To Enter new Phone Number ");
				System.out.println("6. To Enter new Alternate phone number ");
				System.out.println("7. To Save all the fields ");
				System.out.println("8. Go Back( will remove all the unsaved changes) ");
				System.out.println("Enter your Choice >> ");
				func = stdin.nextInt();
				stdin.nextLine();
				switch (func) {
				case 1:
					System.out.print("User Password: ");
					login.user_password = stdin.nextLine();
					break;
				case 2:
					System.out.println("Address Line 1: ");
					address1 = stdin.nextLine();
					break;
				case 3:
					System.out.println("Address Line 2: ");
					address2 = stdin.nextLine();
					break;
				case 4:
					System.out.println("Address Line 3: ");
					address3 = stdin.nextLine();
					break;
				case 5:
					System.out.print("Phone numebr: ");
					ph_no = stdin.nextLine();
					break;
				case 6:
					System.out.print("Alternate phone numebr: ");
					alt_ph_no = stdin.nextLine();
					break;
				case 7:
					update_profile(login);
					System.out.println("Save Success");
					break;
				case 8:
					display_profile(login);
					break;
				default:
					System.out.println("Wrong input. Try again!");
				}
			}while(func!=8);
		}
		/*
		 * If the logged in user is a Faculty
		*/
		else if(login.user_type.equals("F"))
		{
			do
			{
				System.out.println("<Menu>");	
				System.out.println("1. To Enter new User Password: ");
				System.out.println("2. To Save all the fields ");
				System.out.println("3. Go Back( will remove all the unsaved changes) ");
				System.out.println("Enter your Choice >> ");
				func = stdin.nextInt();
				stdin.nextLine();
				switch (func) {
				case 1:
					System.out.print("User Password: ");
					login.user_password = stdin.nextLine();
					break;
				case 2:
					update_profile(login);
					System.out.println("Save Success");
					break;
				case 3:
					display_profile(login);
					break;
				default:
					System.out.println("Wrong input. Try again!");
				}
			}while(func!=3);
		}

	}

	public void display_profile(Login login)
	{
		if(login.user_type.equals("S"))
		{
		System.out.println("Display Student detail");
		}
		else if(login.user_type.equals("F"))
		{
		System.out.println("Display Faculty detail");
		}
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
				if(sex.equals("M"))
				{
					sex = "Male";
				}
				else if(sex.equals("F"))
				{
					sex = "Female";
				}
				//String patron_type = rs.getString("PATRON_TYPE");
				address1 = rs.getString("ADDRESS_LINE_1") != null ? rs.getString("ADDRESS_LINE_1") : "";
				address2 = rs.getString("ADDRESS_LINE_2") != null ? rs.getString("ADDRESS_LINE_2") : "";
				address3 = rs.getString("ADDRESS_LINE_3") != null ? rs.getString("ADDRESS_LINE_3") : "";
				String city = rs.getString("CITY");
				String state = rs.getString("STATE");
				String country = rs.getString("COUNTRY");
				ph_no = rs.getString("PHONE_NUMBER") != null ? rs.getString("PHONE_NUMBER") : "";
				alt_ph_no = rs.getString("ALT_PHONE_NUMBER") != null ? rs.getString("ALT_PHONE_NUMBER") : "";
				String degree_pgm = rs.getString("DEGREE_PROGRAM");
				String st_cat = rs.getString("ST_CATEGORY");
				String st_class = rs.getString("ST_CLASSIFICATION");

				System.out.print("Student Name: ");
				System.out.println(first_name + " " + last_name);
				System.out.print("Date of birth: ");
				System.out.println(dob);
				System.out.print("Department: ");
				System.out.println(dept);
				System.out.print("Nationality: ");
				System.out.println(nationality);
				System.out.print("Sex: ");
				System.out.println(sex);
				//System.out.println(patron_type);
				System.out.println("Address: ");
				System.out.print("Line 1: ");
				System.out.println(address1);
				System.out.print("Line 2: ");
				System.out.println(address2);
				System.out.print("Line 3: ");
				System.out.println(address3);
				System.out.print("City: ");
				System.out.println(city);
				System.out.print("State: ");
				System.out.println(state);
				System.out.print("Country: ");
				System.out.println(country);
				System.out.print("Phone Number: ");
				System.out.println(ph_no);
				System.out.print("Alternate phone numebr: ");
				System.out.println(alt_ph_no);
				System.out.print("Degree Program: ");
				System.out.print(degree_pgm);
				System.out.print("Student Category: ");
				System.out.println(st_cat);
				System.out.print("Student Classification: ");
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
			edit_profile(login);
			break;
		case 2:
			login.home_screen(login);
			break;
		default:
			System.out.println("Wrong input. Try again!");
		}
	}

}
