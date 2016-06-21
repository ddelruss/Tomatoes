

import UIKit

class MovieTableViewController: UITableViewController, UISearchBarDelegate {

    var portfolio = Portfolio()
    var movies = [Movie]()
    let selectedCellBackgroundView = UIView()
    let searchBar = UISearchBar()

    @IBOutlet weak var tableFooterLabel: UILabel!
    
    @IBAction func refresh(sender: UIRefreshControl) {
        portfolio.loadFromServer()
        self.tableView.reloadData()
        sender.endRefreshing()
        searchBar.text = ""
        movies = portfolio.movies
        tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func viewWillDisappear(animated: Bool) {
        portfolio.save()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = portfolio.name
        self.navigationController?.navigationBar.barStyle = .BlackTranslucent
        self.navigationController?.navigationBar.tintColor = Color.Secondary
        self.navigationController?.navigationBar.barTintColor = Color.Background
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Color.Foreground]

        self.tableView.backgroundColor = Color.Background
        self.tableView.separatorColor = Color.Faint

        selectedCellBackgroundView.backgroundColor = Color.CellSelection

        configureSearchBar()
        portfolio.load()
        if (portfolio.movies.count == 0) {
            portfolio.loadDefaultMovies()
        }
        movies = portfolio.movies
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search Movies"
        searchBar.searchBarStyle = .Minimal
        searchBar.barStyle = .Black
        searchBar.backgroundColor = Color.Background
        searchBar.tintColor = Color.Secondary
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return searchBar
    }
    
    private struct Storyboard {
        static let CellReuseIdentifier = "MovieCell"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.CellReuseIdentifier, forIndexPath: indexPath)

        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.name
        cell.textLabel?.textColor = Color.Foreground
        
        cell.detailTextLabel?.text = movie.rating
        cell.detailTextLabel?.textColor = Color.Secondary
        
        cell.accessoryType = .DisclosureIndicator
        cell.imageView?.image = movie.image
                        
        if indexPath.section == 1 { cell.backgroundColor = Color.Action }
        else { cell.backgroundColor = indexPath.row % 2 == 0 ? Color.Cell1 : Color.Cell2 }
        
        cell.selectedBackgroundView = selectedCellBackgroundView

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let movie = movies[indexPath.row]
            movies.removeAtIndex(indexPath.row)
            portfolio.removeMovie(movie)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let movieDetailTVC = segue.destinationViewController as? MovieDetailTableViewController {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPathForCell(cell)!
                movieDetailTVC.movie = movies[indexPath.row]
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }

    // MARK: - SearchBar Delegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            movies = portfolio.movies
        } else {
            movies = portfolio.movies.filter() { nil != $0.name.rangeOfString(searchText) }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        movies = portfolio.movies
        tableView.reloadData()
    }
    
}
