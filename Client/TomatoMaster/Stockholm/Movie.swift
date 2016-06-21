//
//  Movie.swift
//  Tomato
//
//  Created by Damien Del Russo on 6/19/16.
//

import Foundation
import UIKit

class Movie : CustomStringConvertible
{
    var name: String = ""
    var imageUrl: String = ""
    var rating: String = ""
    var movieDescription: String = ""
    var description: String { return "\(name)~\(imageUrl)~\(rating)~\(movieDescription)"}
    var image: UIImage?

    
}