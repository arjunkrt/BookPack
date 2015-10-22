package com.bookpack.jdbc;

public class Resource_check_out {
	
	private static Resource_check_out resource_check_out = new Resource_check_out( );
	
	public static Resource_check_out getInstance( ) {
		return resource_check_out;
	}
	public void display_checked_out_resources(Login login)
	{
		System.out.print("Display Checked out resources");
	}
}
