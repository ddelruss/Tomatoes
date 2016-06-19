var request = require("request");

var base_url = "http://localhost:3000/"

describe("Tomatoes Server Tests", function() {
  describe("GET /", function() {
  
// This test is mostly only relevant before we can create movies
  //   it("returns Default Movie", function(done) {
  //     request.get(base_url, function(error, response, body) {
  //       expect(JSON.parse(body).movie_name).toBe("Default Movie");
  //       done();
  //     });
  //   });
  });
  var movies_url = base_url + "movies"
  describe("GET /movies", function() {

      // it("returns status code 200", function(done) {
      //   request.get(base_url, function(error, response, body) {
      //     expect(response.statusCode).toBe(200);
      //     done();
      //   });
      // });

      it("returns status code 200", function(done) {
        request.get(movies_url, function(error, response, body) {
          expect(response.statusCode).toBe(200);
          done();
        });
      });


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

	 var unmatching_url = movies_url + "?movie_name=UNKNOWN"
  	it("Unmatching query parameter finds nothing", function(done) {
  	  request.get(unmatching_url, function(error, response, body) {
  	    expect(JSON.parse(body).length).toBe(0);
  	    done();
  	   });
  	 });

 	 var exact_matching_url = movies_url + "?movie_name=Default Movie"
   	it("Matching query parameter finds match", function(done) {
   	  request.get(exact_matching_url, function(error, response, body) {
   	    expect(JSON.parse(body).length).toBe(1);
   	    done();
   	   });
   	 });

  	 var partial_matching_url = movies_url + "?movie_name=Defaul" // substring of Default
    	it("Matching query parameter finds match", function(done) {
    	  request.get(partial_matching_url, function(error, response, body) {
    	    expect(JSON.parse(body).length).toBe(1);
    	    done();
    	   });
    	 });
	
  });

	//   describe("POST /movies", function() {
	// var movies_url = base_url + "movies/"
	// it("returns list of movies with 1 item", function(done) {
	//   request.get(movies_url, function(error, response, body) {
	//     expect(JSON.parse(body).length).toBe(1);
	//     done();
	//    });
	//  });
	//  	it("1st movie in list is the default", function(done) {
	//  	  request.get(movies_url, function(error, response, body) {
	// 	  expect(JSON.parse(body)[0].rating).toBe("2.5"); // the default movie
	//  	    done();
	//  	   });
	//  	 });
	//   });

  
});