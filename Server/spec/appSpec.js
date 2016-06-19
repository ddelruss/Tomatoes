var request = require("request");

var baseUrl = "http://localhost:3000/"

describe("Tomatoes Server Tests", function() {

	var loadDefaultMovieUrl = baseUrl + "loadDefaultMovie";
	var moviesUrl = baseUrl + "movies/";
	
  describe("GET /movies", function() {
	 request.post(loadDefaultMovieUrl);
	 var unmatchingUrl = moviesUrl + "?movie_name=UNKNOWN";
	 it("Unmatching query parameter finds nothing", function(done) {
		 request.get(unmatchingUrl, function(error, response, body) {
			 expect(JSON.parse(body).length).toBe(0);
			 done();
		 });
	 });

 	 var exactMatchingUrl = moviesUrl + "?movie_name=Default Movie";
	 it("Matching query parameter finds match", function(done) {
		 request.get(exactMatchingUrl, function(error, response, body) {
			 expect(JSON.parse(body).length).toBe(1);
			 done();
		 });
	 });

  	 var partialMatchingUrl = moviesUrl + "?movie_name=faul" // substring of Default
	 it("Matching query parameter finds match", function(done) {
		 request.get(partialMatchingUrl, function(error, response, body) {
			 expect(JSON.parse(body).length).toBe(1);
			 done();
		 });
	 });
 });

 describe("POST /movies", function() {
	 var formData = { "marker": "This is a test body"};

	 it("posted fails for missing movie_name", function(done) {
		 formData = { 
			 // "movie_name": "Any movie name",
		 	"image_url": "any URL",
			 "rating": "any rating",
			 "description": "any description"}
			 
		request.post(moviesUrl, function(error, response, body) {
			expect(response.statusCode).toBe(422);
			done();
		});
	 });

	 it("posted fails for missing image_url", function(done) {
		 formData = { 
			 "movie_name": "Any movie name",
		 	// "image_url": "any URL",
			 "rating": "any rating",
			 "description": "any description"}
	 		request.post({url: moviesUrl, form: formData}, function(error, response, body) {
	 			expect(response.statusCode).toBe(422);
	 			done();
	 		});
	 });

	 it("posted fails for missing rating", function(done) {
		 formData = { 
			 "movie_name": "Any movie name",
		 	"image_url": "any URL",
			 // "rating": "any rating",
			 "description": "any description"}
	 		request.post({url: moviesUrl, form: formData}, function(error, response, body) {
	 			expect(response.statusCode).toBe(422);
	 			done();
	 		});
	 });
	 
	 it("posted fails for missing description", function(done) {
		 formData = { 
			 "movie_name": "Any movie name",
		 	"image_url": "any URL",
			 "rating": "any rating",
			 // "description": "any description"
		 }
	 		request.post({url: moviesUrl, form: formData}, function(error, response, body) {
	 			expect(response.statusCode).toBe(422);
	 			done();
	 		});
	 });

	 it("posted succeeds for valid movie", function(done) {
	 		 // request.post(resetMoviesUrl);  // causes race condition error
	     	var exactMatchingUrl = moviesUrl + "?movie_name=Valid Movie";

	 		formData = {
	 			 "movie_name": "Valid Movie",
	 		 	"image_url": "Valid URL",
	 			 "rating": "Valid rating",
	 			 "description": "Valid description"
	 		 }
	  		request.post(moviesUrl).form(formData);
	 		request.get(exactMatchingUrl, function(error, response, body) {
	 		 	expect(JSON.parse(body).length).toBe(1);
	 			if (JSON.parse(body).length > 0) {
	 				var body = JSON.parse(body)[0];
	 				expect(body.movie_name).toBe("Valid Movie");
	 				expect(body.rating).toBe("Valid rating");
	 				expect(body.image_url).toBe("Valid URL");
	 				expect(body.description).toBe("Valid description");
	 			}
	 			done();
	 		});
	 });
	 
	 it("posted fails for an existing movie", function(done) {
		 // request.post(resetMoviesUrl);  // exacerbates race condition errors
	 		formData = {
	 			 "movie_name": "Repeat Movie",
	 		 	"image_url": "any URL",
	 			 "rating": "any rating",
	 			 "description": "any description"
	 		 }
	 	 request.post({url: moviesUrl, form: formData});
	  		formData = {
	  			 "movie_name": "Repeat Movie",
	  		 	"image_url": "different URL",
	  			 "rating": "different rating",
	  			 "description": "different description"
	  		 }
	  		request.post({url: moviesUrl, form: formData}, function(error, response, body) {
	  			expect(response.statusCode).toBe(409);
	  			done();
	  		});

	 });
	 
 });
  
});