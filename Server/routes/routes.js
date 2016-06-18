var appRouter = function(app) {
 
 	var storage = require('node-persist')
	storage.initSync();
	loadDefaultData();
	//storage.clear();
	//storage.setItem('name','Damien');
	//console.log(storage.getItem('name'));
	
	app.get("/", function(req, res) {
	    res.send(storage.getItem('default'));
	});
	
	function loadDefaultData() {
		if (storage.values.size == 0) {
			var aMovie = {
				movie_name: "A Movie Name",
				image_url: "http://ielts-results.weebly.com/uploads/4/0/6/6/40661105/1113084_orig.jpg",
				rating: "2.5",
				description: "A compelling movie description updated"
			}
			storage.setItem('default', aMovie)
		}
	}
}
 
module.exports = appRouter;