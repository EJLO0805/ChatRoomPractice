//
//  FemaleTableViewCell.swift
//  ChatRoomPractice
//
//  Created by 羅以捷 on 2023/1/29.
//

import UIKit

class FemaleTableViewCell: UITableViewCell {

    @IBOutlet weak var femaleImage: UIImageView!{
        didSet{
            femaleImage.layer.borderWidth = 1
            femaleImage.layer.cornerRadius = 25
            femaleImage.layer.borderColor = UIColor.darkGray.cgColor
            femaleImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var femaleContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
