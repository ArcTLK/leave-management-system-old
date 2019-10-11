function onSignIn(googleUser) {
	const token = googleUser.getAuthResponse().id_token;
	$.post('/LoginServlet', { token }, data => {
		location.reload();
	}).fail(data => {
		$('#loginError').html((JSON.parse(data.responseText)).error);
		signOut(false);
	});
	const profile = googleUser.getBasicProfile();
	console.log('ID: ' + profile.getId()); // Do not send to your backend! Use an ID token instead.
	console.log('Name: ' + profile.getName());
	console.log('Image URL: ' + profile.getImageUrl());
	console.log('Email: ' + profile.getEmail()); // This is null if the 'email' scope is not present.
}
function signOut(reload = true) {
    var auth2 = gapi.auth2.getAuthInstance();
    $.ajax({
        url: '/LoginServlet',
        type: 'DELETE'
    });
    auth2.signOut().then(function () {
    	if (reload) location.reload();
    });
}
function onLoad() {
    gapi.load('auth2', function() {
      gapi.auth2.init();
    });
}
$(document).ready(() => {
	onLoad();
})