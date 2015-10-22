package com.bookpack.jdbc;

public class Profile {
	private static Profile profile = new Profile( );
	
	public static Profile getInstance( ) {
		return profile;
	}
	public void display_student(Login login)
	{
		System.out.print("Display student detail");
	}

}
