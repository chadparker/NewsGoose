//
//  PostCell.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/31/21.
//

import UIKit

protocol PostCellDelegate {
    func showComments(id: String)
}

class PostCell: UITableViewCell {
    
    var post: Post! {
        didSet {
            updateViews()
        }
    }
    var delegate: PostCellDelegate!
    
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
    
    @IBAction func viewComments(_ sender: UIButton) {
        guard let id = post.id else {
            fatalError("Post has no `id`")
        }
        delegate.showComments(id: id)
    }
}
