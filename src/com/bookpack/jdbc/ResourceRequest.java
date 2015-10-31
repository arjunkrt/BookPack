package com.bookpack.jdbc;

import java.util.Scanner;

public class ResourceRequest {
	
	static Scanner stdin = new Scanner(System.in);
	private static ResourceRequest resource_request = new ResourceRequest( );
	
	public static ResourceRequest getInstance( ) {
		return resource_request;
	}
	public void display_requested_resources(Login login)
	{
		System.out.println("Display Requested resources");
		
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
