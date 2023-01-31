//
//  MaleTableViewCell.swift
//  ChatRoomPractice
//
//  Created by 羅以捷 on 2023/1/29.
//

import UIKit

class MaleTableViewCell: UITableViewCell {

    @IBOutlet weak var maleImage: UIImageView!{
        didSet{
            maleImage.layer.borderWidth = 1
            maleImage.layer.cornerRadius = 25
            maleImage.layer.borderColor = UIColor.darkGray.cgColor
            maleImage.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var maleContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
