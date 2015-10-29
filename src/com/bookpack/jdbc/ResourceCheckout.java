package com.bookpack.jdbc;

import java.util.Scanner;

public class ResourceCheckout {
	
	static Scanner stdin = new Scanner(System.in);
	private static ResourceCheckout resource_check_out = new ResourceCheckout( );
	
	public static ResourceCheckout getInstance( ) {
		return resource_check_out;
	}
	public void display_checked_out_resources(Login login)
	{
		System.out.println("Display Checked out resources");
		
		System.out.println("<Menu>");	
		System.out.println("1. GO back");
		System.out.print("Enter your Choice >> ");

		int func = stdin.nextInt();
		stdin.nextLine();
		switch (func) {
		case 1:
			login.home_screen(login);
			break;
		default:
			System.out.println("Wrong input. Try again!");
		}
	}
}
