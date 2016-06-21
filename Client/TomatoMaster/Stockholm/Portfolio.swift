
import Foundation
import UIKit

class Portfolio : CustomStringConvertible {
    private var _movies = [Movie]()
    var movies: [Movie] {
        get {
            let copy = _movies
            return copy         // users can not mess with our real movie array
        }
    }
    
    var name = "Fresh Tomatoes"
    
    var description: String {
        return movies.description
    }
    
    func addMovie(movie: Movie) {
        loadMovieImage(movie)

        _movies.append(movie)
        _movies.sortInPlace { return $0.name < $1.name }
        save()
    }
    
    func loadMovieImage(movie: Movie) {
        let url = NSURL(string: movie.imageUrl)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let data = NSData(contentsOfURL: url!)  // this is unsafe unwrapping - to protect against bad data use let statements
            dispatch_async(dispatch_get_main_queue(), {
                if let successfulData = data {
                    movie.image = UIImage(data: successfulData)
                }
            });
        }
        // it would be nice to communicate to the UI that this is done, however I didn't have time to setup proper notifications with MVC practices
    }
    
    func removeMovie(movie: Movie) {
        if let index = _movies.indexOf({$0.name == movie.name}) {
            _movies.removeAtIndex(index)
            save()
        }
    }
    
    var contents: AnyObject { // guaranteed to be a property list
        get {
            return movies.map { $0.description }
        }
        set {
            if let movieDescriptions = newValue as? Array<String> {
                _movies.removeAll()
                
                for movieDescription in movieDescriptions {
                    let components = movieDescription.componentsSeparatedByString("~")
                    let movie = Movie()
                    movie.name = components[0]
                    movie.imageUrl = components[1]
                    movie.rating = components[2]
                    movie.movieDescription = components[3]
                    loadMovieImage(movie)
                    _movies.append(movie)
                }
                _movies.sortInPlace { return $0.name < $1.name }
            } else {
                print("ERROR: Could not cast contents.")
            }
        }
    }
    
    private struct Persistence {
        static let UserDefaultsKey = "Tomato Portfolio"
    }

    func save() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(contents, forKey: Persistence.UserDefaultsKey)
        print("Portfolio saved to disk.")
    }
    
    func load() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let loadedContents = defaults.objectForKey(Persistence.UserDefaultsKey) {
            contents = loadedContents
        }
        print("Portfolio loaded from disk.")
    }
    
    func loadFromServer() {
        print("Loading movies from server...")
        //        let url = NSURL(string: "127.0.0.1:3000/movies")
        let url = NSURL(string: "https://private-05248-rottentomatoes.apiary-mock.com/")
        
        do {
            let json = NSData(contentsOfURL: url!)
            let moviesDictionary = try! NSJSONSerialization.JSONObjectWithData(json!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            let movieArray = moviesDictionary.allValues[0] as! NSArray
            for movie in movieArray {
                let movieDict = movie as! NSDictionary
                let newMovie = Movie()
                newMovie.name = movieDict.valueForKey("movie_name") as! String
                newMovie.imageUrl = movieDict.valueForKey("image_url") as! String
                newMovie.rating = movieDict.valueForKey("rating") as! String
                newMovie.movieDescription = movieDict.valueForKey("description") as! String
                addMovie(newMovie)
            }
        }
        print("Got to end of loadFromServer")
    }
    
    func loadDefaultMovies() {
        let movie1 = Movie()
        movie1.name = "Fight Club"
        movie1.imageUrl = "https://ia.media-imdb.com/images/M/MV5BMjIwNTYzMzE1M15BMl5BanBnXkFtZTcwOTE5Mzg3OA@@._V1_UY1200_CR88,0,630,1200_AL_.jpg"
        movie1.rating = "5.0"
        movie1.movieDescription = "The most unreliable narrator ever."
        addMovie(movie1)
        
        let movie2 = Movie()
        movie2.name = "Forrest Gump"
        movie2.imageUrl = "https://t3.gstatic.com/images?q=tbn:ANd9GcQCFOcMb5_zkdZg4B4JvIGLlTQTvLdtLjiS5axJJDqP1FaI8Yyx"
        movie2.rating = "4.5"
        movie2.movieDescription = "Run Forrest Run to see this classic!"
        addMovie(movie2)
        print("Default movies loaded from code.")
    }
    
}