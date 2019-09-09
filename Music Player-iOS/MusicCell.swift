//
//  MusicCell.swift
//  Music Player-iOS
//
//  Created by Teodor Stanishev on 23.07.19.
//  Copyright © 2019 Teodor Stanishev. All rights reserved.
//

import UIKit


class MusicCell:UITableViewCell{
    
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var songDurationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                coverImage.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                coverImage.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    func setPostedImage(image : UIImage) {
        
        let aspect = image.size.width / image.size.height
        
        aspectConstraint = NSLayoutConstraint(item: coverImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: coverImage, attribute: NSLayoutConstraint.Attribute.height, multiplier: aspect, constant: 0.0)
        
        coverImage.image = image
    }
}
