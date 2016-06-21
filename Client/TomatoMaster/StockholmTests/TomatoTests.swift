
import XCTest
@testable import Stockholm

class TomatoTests: XCTestCase {

    var portfolio = Portfolio()
    var movie = Movie()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: Portfolio Tests
    func testPortfolioStartsEmpty() {
        XCTAssert(portfolio.movies.count == 0, "Portfolio should be empty")
    }

    func testPortfolioAddsStock() {
        let aMovie = Movie()
        aMovie.name = "A Movie"
        portfolio.addMovie(aMovie)
        XCTAssertEqual(portfolio.movies.last?.name, "A Movie", "Movie should be in portfolio.")
    }
    
    func addMovieWithName(name: String) {
        let aNewMovie = Movie()
        aNewMovie.name = name
        portfolio.addMovie(aNewMovie)
    }
    func testPortfolioRemovesStock() {
        addMovieWithName("TEST0")
        addMovieWithName("TEST1")
        addMovieWithName("TEST2")
        XCTAssertEqual(portfolio.movies.count, 3, "Portfolio should have 3 movies.")
        
        let movieToRemove = portfolio.movies.last!
        portfolio.removeMovie(movieToRemove)
        XCTAssertEqual(portfolio.movies.count, 2, "Portfolio should have 2 movies.")
        XCTAssertEqual(portfolio.movies.last!.name, "TEST1", "Last movie should be 2nd one added.")
        let nextToRemove = portfolio.movies.first!
        portfolio.removeMovie(nextToRemove)
        XCTAssertEqual(portfolio.movies.count, 1, "Portfolio should have 1 movie.")
        XCTAssertEqual(portfolio.movies.first!.name, "TEST1", "First movie should be 2nd one added.")
        // nothing should happen when you remove a movie again
        portfolio.removeMovie(movieToRemove)
        portfolio.removeMovie(nextToRemove)
        XCTAssertEqual(portfolio.movies.count, 1, "Portfolio should have 1 movie.")
        XCTAssertEqual(portfolio.movies.first!.name, "TEST1", "First movies should be 2nd one added.")
    }
    
    func testPortfolioUnloadingAndLoading() {
        addMovieWithName("TEST1")
        addMovieWithName("TEST2")

        print("Portfolio contents: \(portfolio.contents as! Array<String>)")
        if let movie = portfolio.movies.first {
            movie.rating = "3.0"
        }
        let contents = portfolio.contents as! Array<String>
        var movie = portfolio.movies.first!
        portfolio.removeMovie(movie)
        movie = portfolio.movies.first!
        portfolio.removeMovie(movie)
        XCTAssertEqual(portfolio.movies.count, 0, "Portfolio should be empty.")
        
        portfolio.contents = contents
        XCTAssertEqual(portfolio.movies.count, 2, "Portfolio should be reconstituted.")
        movie = portfolio.movies.first!
        XCTAssertEqual(movie.rating, "3.0", "Movie rating should be preserved.")
    }
    
}
