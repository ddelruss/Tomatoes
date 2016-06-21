

import UIKit

class MovieDetailTableViewController: UITableViewController, UIGestureRecognizerDelegate {

    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = movie?.name
        self.tableView.backgroundColor = Color.Background
        self.tableView.separatorColor = Color.Faint
        self.tableView.tintColor = Color.Foreground // sets the little i accessory view color
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
 
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let imageView = UIImageView(image: movie!.image)
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.frame.height * 0.6  // magic number that adjusts pretty well for rotations and different devices
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath.row == 2) {
            // estimating about 100 characters fit on a line - normally you'd do with by measuring the size required for the formatted text

            let length = movie?.movieDescription.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)
            let multiplier = (length! + 100) / 100         // rough guess, again this is not how you would build a real app
            let computedHeight = CGFloat(multiplier) * 44  // would use tableview.rowHeight but it is -1 for some reason
            return computedHeight
        }
        
        return tableView.rowHeight  // the -1 is not problematic here
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieDetail", forIndexPath: indexPath)

        cell.userInteractionEnabled = false
        cell.accessoryType = .None
        cell.textLabel?.textColor = Color.Secondary
        cell.detailTextLabel?.textColor = Color.Foreground
        cell.backgroundColor = Color.Cell2
        
        switch indexPath.row {
        case 0: cell.textLabel?.text = "Title"
                cell.detailTextLabel?.text = movie?.name
        case 1: cell.textLabel?.text = "Rating: "
                cell.detailTextLabel?.text = movie?.rating
        case 2: cell.textLabel?.text = "Description"
                cell.detailTextLabel?.text = movie?.movieDescription
            
        default: cell.textLabel?.text = "error - row should not exist"
        }
        return cell
    }
    
}
