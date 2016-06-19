var request = require("request");

var base_url = "http://localhost:3000/"

describe("Tomatoes Server Tests", function() {
  describe("GET /", function() {
    it("returns status code 200", function(done) {
      request.get(base_url, function(error, response, body) {
        expect(response.statusCode).toBe(200);
        done();
      });
    });

// This test is mostly only relevant before we can create movies
    it("returns Default Movie", function(done) {
      request.get(base_url, function(error, response, body) {
        expect(JSON.parse(body).movie_name).toBe("Default Movie");
        done();
      });
    });
  });
  describe("GET /movies", function() {
	var movies_url = base_url + "movies/"
	it("returns list of movies with 1 item", function(done) {
	  request.get(movies_url, function(error, response, body) {
	    expect(JSON.parse(body).length).toBe(1);
	    done();
	   });
	 });
 	it("1st movie in list is the default", function(done) {
 	  request.get(movies_url, function(error, response, body) {
		  expect(JSON.parse(body)[0].rating).toBe("2.5"); // the default movie
 	    done();
 	   });
 	 });
  });

  
});