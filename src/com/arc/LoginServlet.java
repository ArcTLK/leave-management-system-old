package com.arc;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.GeneralSecurityException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collections;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload;
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.auth.openidconnect.IdToken;
import com.google.api.client.auth.openidconnect.IdTokenVerifier;
import com.google.api.client.http.HttpTransport;
import com.google.api.client.http.apache.ApacheHttpTransport;
import com.arc.Database;
/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static final String CLIENT_ID = "188419469527-usdhao1pp0kgaammglv15r9s9d7al26o.apps.googleusercontent.com";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public LoginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpTransport transport = new ApacheHttpTransport();
		GoogleIdTokenVerifier verifier = new GoogleIdTokenVerifier.Builder(transport, JacksonFactory.getDefaultInstance())
			    .setAudience(Collections.singletonList(CLIENT_ID))
			    .build();

		GoogleIdToken idToken;
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		Connection connection = null;
		try {
			idToken = verifier.verify(request.getParameter("token"));
			if (idToken != null) {
				  Payload payload = idToken.getPayload();
				  if (payload.getHostedDomain() == "student.mes.ac.in" || payload.getHostedDomain() == "mes.ac.in") {
					  String userId = payload.getSubject();
					  String email = payload.getEmail();
					  String name = (String) payload.get("name");
					  String pictureUrl = (String) payload.get("picture");
					  String familyName = (String) payload.get("family_name");
					  String givenName = (String) payload.get("given_name");
					  
					  connection = Database.getConnection();
					  preparedStatement = connection.prepareStatement("SELECT id, google_id, email, name, hod, picture_url FROM users WHERE google_id = ?");
					  preparedStatement.setString(0, userId);
					  resultSet = preparedStatement.executeQuery();
					  //TODO add data to session
					  
					  if (resultSet.next() == false) {
						  resultSet.close();
						  preparedStatement.close();
						  resultSet = null;
						  preparedStatement = null;
						  //insert
						  preparedStatement = connection.prepareStatement("INSERT INTO users (google_id, email, name, picture_url) VALUES (?, ?, ?, ?)");
						  preparedStatement.setString(0, userId);
						  preparedStatement.setString(1, email);
						  preparedStatement.setString(2, name);
						  preparedStatement.setString(3, pictureUrl);
						  preparedStatement.execute();
					  }
					  else {
						  resultSet.close();
						  preparedStatement.close();
						  resultSet = null;
						  preparedStatement = null;
						  //update
						  preparedStatement = connection.prepareStatement("UPDATE users SET email = ?, name = ?, picture_url = ? WHERE google_id = ?");
						  preparedStatement.setString(3, userId);
						  preparedStatement.setString(0, email);
						  preparedStatement.setString(1, name);
						  preparedStatement.setString(2, pictureUrl);
						  preparedStatement.execute();
					  }
					  response.setContentType("application/json");
					  response.getWriter().append("{\"result\":true}");
				  }
				  else {
					  response.setContentType("application/json");
					  response.getWriter().append("{\"result\":false, \"error\":\"Invalid Domain\"}");
				  }
				}
		} catch (GeneralSecurityException e) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.getWriter().append("{\"result\":false, \"error\":\"Security Error\"}");
		} catch (SQLException e) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.getWriter().append("{\"result\":false, \"error\":\"Database Error\"}");
		} catch (URISyntaxException e) {
			response.setStatus(500);
			response.setContentType("application/json");
			response.getWriter().append("{\"result\":false, \"error\":\"Database Error\"}");
		} finally {
			try {
				if (resultSet != null) resultSet.close();
				if (preparedStatement != null) preparedStatement.close();
				if (connection != null) connection.close();
			} catch(SQLException e) {
				response.setStatus(500);
				response.setContentType("application/json");
				response.getWriter().append("{\"result\":false, \"error\":\"Database Error\"}");
			}
		}
	}

}
