package com.bookpack.jdbc;

import java.sql.*;
import java.util.Scanner;

public class Main {
	static Scanner stdin = new Scanner(System.in);

	public static void main(String[] args) {

		int func;

		do {
			System.out.println();
			System.out.println("BookPack! Library Management System");
			System.out.println("----------------------------------");
			System.out.println("<Menu>");	
			System.out.println("1. Login");
			System.out.println("2. Quit");
			System.out.print("Enter your Choice >> ");
			func = stdin.nextInt();
			stdin.nextLine();
			switch (func) {
			case 1:
				DBConnection cobj = new DBConnection();
				cobj.JDBCConnection(); 
				Login login = Login.getInstance();
				login.login_screen();
				if (login.success_id > 0) {
					
					System.out.println("----------------------------------");
					System.out.println("<Menu>");	
					System.out.println("1. Profile");
					System.out.println("2. Resources");
					System.out.println("3. Checked­out Resources");
					System.out.println("4. Resource Request");
					System.out.println("5. Notifications");
					System.out.println("6. Due­Balance");
					System.out.println("7. Logout");
					System.out.print("Enter your Choice >> ");
					func = stdin.nextInt();
					stdin.nextLine();
					switch (func) {
					case 1:
						Profile profile = Profile.getInstance();
						profile.display_student(login);
						break;
					case 2:
						
						break;
					case 3:
						Resource_check_out resource_check_out = Resource_check_out.getInstance();
						resource_check_out.display_checked_out_resources(login);
						break;
					default:
						System.out.println("Wrong input. Try again!");
					}
					
				}
				break;
			case 2:
				System.out.println("Bye!!!!!!!!!!!!!!!!!!!!!!!");
				break;
			default:
				System.out.println("Wrong input. Try again!");
			}
		}
		while (func != 2);
	}

}
