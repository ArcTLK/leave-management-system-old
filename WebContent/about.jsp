<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.arc.*" %>
<%! User user; %>
<% user = (User)session.getAttribute("user"); %>
<!DOCTYPE html>
<html>
	<head>
		<title>Leave Management System</title>
		<meta charset="ISO-8859-1">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="google-signin-client_id" content="188419469527-usdhao1pp0kgaammglv15r9s9d7al26o.apps.googleusercontent.com">
		<link href="https://fonts.googleapis.com/css?family=Noto+Sans&display=swap" rel="stylesheet">
		<link rel="stylesheet" type="text/css" href="./style.css">
		<script src="https://apis.google.com/js/platform.js?onload=onLoad" async defer></script>
		<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous"></script>
		<script src="./main.js"></script>
	</head>
	<body>
		<div class="top-bar">
			<img src="./pcelogo.png">
			<nav class="navbar">
				<a href="/">Home</a>
				<a href="/about.jsp">About</a>
				<c:if test="${user != null}">
					<button onclick="signOut()" class="sign-out-button">Sign out</button>
				</c:if>
			</nav>
		</div>
		<div class="content">
			<h1>Leave Management System (Version 1)</h1>
			<h2>Created by:</h2>
			<ul>
				<li>Aditya Nair</li>
				<li>Kaustubh Sawant</li>
				<li>Alex Vetillathanam</li>
				<li>Manish Jadhav</li>
			</ul>
		</div>
	</body>
</html>
    