package com.arc;

public class User {
	public int id;
	public String name;
	public String pictureUrl;
	public String email;
	public String googleId;
	public int hod;
	public static final int ALLOWED_LEAVES = 3;
	
	User(int id, String name, String pictureUrl, String email, String googleId, int hod) {
		this.googleId = googleId;
		this.id = id;
		this.name = name;
		this.pictureUrl = pictureUrl;
		this.hod = hod;
		this.email = email;
	}
	public int getHod() {
		return this.hod;
	}
}
