<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
	<head>
		<title>Leave Management System</title>
		<meta charset="ISO-8859-1">
		<meta name="google-signin-client_id" content="188419469527-usdhao1pp0kgaammglv15r9s9d7al26o.apps.googleusercontent.com">
		<script src="https://apis.google.com/js/platform.js" async defer></script>
		<script src="./main.js" async defer></script>
		<script
  src="https://code.jquery.com/jquery-3.4.1.min.js"
  integrity="sha256-CSXorXvZcTkaix6Yvo6HppcZGetbYMGWSFlBw8HfCJo="
  crossorigin="anonymous" async defer></script>
	</head>
	<body>
		<h1>Leave Management System</h1>
		<c:if test="${1 == 1}">
			<div class="g-signin2" data-onsuccess="onSignIn"></div>
		</c:if>
		<c:if test="${1 == 1}">
			<jsp:include page="./faculty.jsp" flush="true" />
		</c:if>
		<c:if test="${1 == 1}">
			<jsp:include page="./hod.jsp" flush="true" />
		</c:if>
	</body>
</html>
