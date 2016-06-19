var appRouter = function(app) {
 
 	var storage = require('node-persist')
	storage.initSync();
	// storage.clear(); // use this to empty storage until we add a delete feature
	loadDefaultData();
	//storage.setItem('name','Damien');
	//console.log(storage.getItem('name'));
	
	// app.get("/", function(req, res) {
	// 	console.log("Current db size %s", storage.values().length);
	//     // res.send(storage.getItem('default').movie_name);
	// 	var value = storage.getItem('default')
	// 	console.log("Returning:\n%s", value)
	//     res.send(value);
	// });

	app.get("/movies", function(req, res) {
		// console.log("Current db size %s", storage.values().length);
		console.log(req.query)
		// var	values = req.query.movie_name ? storage.valuesWithKeyMatch(req.query.movie_name) : storage.values()
		var values = storage.values()
		var searchTerm = req.query.movie_name
		function match(movie) {
			return movie.movie_name.indexOf(searchTerm) > -1
		}
		var filterValues = searchTerm ? values.filter(match) : values
		res.send(filterValues)
	});
	
	function loadDefaultData() {
		if (storage.values().length == 0) {
			var aMovie = {
				movie_name: "Default Movie",
				image_url: "http://ielts-results.weebly.com/uploads/4/0/6/6/40661105/1113084_orig.jpg",
				rating: "2.5",
				description: "A compelling movie description"
			}
			storage.setItem(aMovie.movie_name, aMovie)
		}
	}
	
	function match(movie, search) {
		console.log("Comparing %s to %s", movie.movie_name, searc)
		return movie.movie_name.indexOf(search) > -1
	}
}
 
module.exports = appRouter;