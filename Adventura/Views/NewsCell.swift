//
//  NewsCell.swift
//  Adventura
//
//  Created by Jun on 2023/08/25.
//

import UIKit

class NewsCell: UITableViewCell {

    
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var labelOutlet: UILabel!
    
    @IBOutlet weak var stackViewOutlet: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
