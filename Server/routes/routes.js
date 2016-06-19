var appRouter = function(app) {
 
 	var storage = require('node-persist')
	storage.initSync();
	// storage.clear(); // use this to empty storage until we add a delete feature
	loadDefaultData();
	//storage.setItem('name','Damien');
	//console.log(storage.getItem('name'));
	
	app.get("/", function(req, res) {
		console.log("Current db size %s", storage.values().length);
	    // res.send(storage.getItem('default').movie_name);
		var value = storage.getItem('default')
		console.log("Returning:\n%s", value)
	    res.send(value);
	});

	app.get("/movies", function(req, res) {
		console.log("Current db size %s", storage.values().length);
		var values = storage.values()
		console.log("Returning:\n%s", values)
	    res.send(values);
	});
	
	function loadDefaultData() {
		if (storage.values().length == 0) {
			var aMovie = {
				movie_name: "Default Movie",
				image_url: "http://ielts-results.weebly.com/uploads/4/0/6/6/40661105/1113084_orig.jpg",
				rating: "2.5",
				description: "A compelling movie description updated"
			}
			storage.setItem('default', aMovie)
		}
	}
}
 
module.exports = appRouter;