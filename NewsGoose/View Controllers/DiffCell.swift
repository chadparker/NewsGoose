//
//  DiffCell.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/10/21.
//

import UIKit

class DiffCell: UICollectionViewCell {

    static let reuseIdentifier = "DiffCell"

    @IBOutlet weak var label: UILabel!

    var text: String! {
        didSet {
            label.text = text
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .init(white: 0.95, alpha: 1.0)
    }
}
