//
//  FeedViewCell.swift
//  MDBSocials
//
//  Created by Aditya Yadav on 2/20/18.
//  Copyright © 2018 Aditya Yadav. All rights reserved.
//

import UIKit
import Hero

class FeedViewCell: UICollectionViewCell {
    
    var image: UIImageView!
    var nameLabel: UILabel!
    var eventLabel: UILabel!
    var starImageView: UIImageView!
    var RSVP: UILabel!
    var date: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpCell()
    }
    
    func setUpCell() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        image = UIImageView(frame: CGRect(x: 0, y: 0, width: contentView.frame.height, height: contentView.frame.height))
        contentView.addSubview(image)
        
        let starImage = UIImage(named: "star")
        self.starImageView = UIImageView(frame: CGRect(x: contentView.frame.width - 57, y: 120, width: 17, height: 17))
        self.starImageView.image = starImage
        contentView.addSubview(starImageView)
        
        let mainTextColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
        let secondTextColor = UIColor(red: 149/255, green: 165/255, blue: 166/255, alpha: 1.0)
        
        eventLabel = UILabel(frame: CGRect(x: self.image.frame.width + 10, y: 10, width: contentView.frame.width - image.frame.width - 15, height: 30))
        eventLabel.textColor = mainTextColor
        eventLabel.numberOfLines = 0
        eventLabel.font = UIFont(name: "HelveticaNeue-Light", size: 19)
        contentView.addSubview(eventLabel)
        
        nameLabel = UILabel(frame: CGRect(x: self.image.frame.width + 10, y: 40, width: contentView.frame.width - image.frame.width - 15, height: 30))
        nameLabel.textColor = secondTextColor
        nameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.numberOfLines = 2
        contentView.addSubview(nameLabel)
        
        date = UILabel(frame: CGRect(x: self.image.frame.width + 10, y: 70, width: contentView.frame.width - image.frame.width - 20, height: 30))
        date.textColor = secondTextColor
        date.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        date.adjustsFontSizeToFitWidth = true
        contentView.addSubview(date)
        
        RSVP = UILabel(frame: CGRect(x: contentView.frame.width - 33, y: 120, width: 20, height: 20))
        RSVP.textColor = secondTextColor
        RSVP.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        contentView.addSubview(RSVP)
        
        eventLabel.text = ""
        nameLabel.text = ""
        RSVP.text = ""
        
        self.clipsToBounds = true
    }
    
    
    
    
    
}
