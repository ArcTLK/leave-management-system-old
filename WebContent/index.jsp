<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.arc.*" %>
<%! User user; %>
<% 
	user = (User)session.getAttribute("user");
%>
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
		<c:if test="${user == null}">
			<div class="sign-in-box">
				<h1 style="text-align:center">Sign in using MES ID</h1>
				<div class="sign-in-button">
					<div class="g-signin2" data-onsuccess="onSignIn"></div>
					<div id="loginError"></div>
				</div>
			</div>
		</c:if>
		<c:if test="${user != null && user.hod == 0}">
			<jsp:include page="./faculty.jsp" flush="true" />
		</c:if>
		<c:if test="${user != null && user.hod == 1}">
			<jsp:include page="./hod.jsp" flush="true" />
		</c:if>
	</body>
</html>
