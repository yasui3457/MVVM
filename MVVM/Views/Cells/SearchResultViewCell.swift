//
//  SearchResultViewCell.swift
//  FatViewController
//
//  Created by 安井陸 on 2019/06/15.
//  Copyright © 2019 安井陸. All rights reserved.
//

import UIKit

class SearchResultViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    var url: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var result: Article? {
        didSet {
            guard let result = result else {return}
            titleLabel.text = result.title
            textLabel.text = result.body
            url = result.url
        }
    }
    
}
