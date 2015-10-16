package com.bookpack.jdbc;

import java.util.Scanner;

public class search {
	
	public static String search_resource(){
		
		while(true){
			
			System.out.println("1. Search Book. ");
			System.out.println("2. Search Research Journal. ");
			System.out.println("3. Search Camera. ");
			System.out.println("4. Search Room. ");
			
			Scanner in = new Scanner(System.in);
			int num = in.nextInt();
			
			String sql = "{ ? = call USER_AUTH.SEARCH_RESOURCE(?) }";
			return sql;
			
		}
		
	}

}
