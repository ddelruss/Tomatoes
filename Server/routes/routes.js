var appRouter = function(app) {
 
 	var storage = require('node-persist');
	storage.initSync();
	storage.clearSync();  // empties database each time server is started - remove for better persistence.

	app.get("/movies", function(req, res) {
		console.log("GET. Current db size %s. Query is: %s", storage.values().length, JSON.stringify(req.query));
		var values = storage.values();
		var searchTerm = req.query.movie_name;
		console.log("Result for %s as search term versus %s is", searchTerm, values[0].movie_name)
		function match(movie) {
			return movie.movie_name.indexOf(searchTerm) > -1;
		}
		var filterValues = searchTerm ? values.filter(match) : values;
		console.log("Returning filtered values: %s", JSON.stringify(filterValues));
		res.send(filterValues);
	});

	app.post("/movies", function(req, res) {
		console.log("POST. Current db size is %s. Body is: %s", storage.values().length, JSON.stringify(req.body));
		if (!req.body.movie_name || !req.body.image_url || !req.body.rating || !req.body.description) {
			console.log("Missing required data, returning error.");
			res.statusCode = 422;
			res.send();
			return;
		} 
		
		if (storage.getItemSync(req.body.movie_name)) {
			console.log("Duplicate key error, not adding to db and returning error.");
			res.statusCode = 409;
			res.send();
			return;
		}
		
		var newMovie = {
			movie_name: req.body.movie_name,
			image_url: req.body.image_url,
			rating: req.body.rating,
			description: req.body.description
		};
		storage.setItemSync(req.body.movie_name, newMovie);
			
		console.log("POST updated db size is %s", storage.values().length);
		res.send();			
	});
	
	// convenience method
	app.post("/loadDefaultMovie", function(req, res) {
		console.log("Loading default movie");
		loadDefaultData();
		console.log("New db size: %s", storage.values().length);
		res.sendStatus(200);
	});
	
	function loadDefaultData() {
		if (storage.values().length == 0) {
			var aMovie = {
				movie_name: "Default Movie",
				image_url: "http://ielts-results.weebly.com/uploads/4/0/6/6/40661105/1113084_orig.jpg",
				rating: "2.5",
				description: "A compelling movie description"
			};
			storage.setItemSync(aMovie.movie_name, aMovie);
		}
	}
	
}
 
module.exports = appRouter;