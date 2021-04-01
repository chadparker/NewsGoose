//
//  PostCell.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/31/21.
//

import UIKit

class PostCell: UITableViewCell {
    
    var post: Post! {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var linkTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViews() {
        pointsLabel.text = "\(post.points)"
        linkTextLabel.text = post.link_text
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
