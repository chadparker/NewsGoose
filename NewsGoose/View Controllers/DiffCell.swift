//
//  DiffCell.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/10/21.
//

import UIKit
import NGCore

class DiffCell: UICollectionViewCell {

    var post: Post! {
        didSet {
            updateViews()
        }
    }

    private let postLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setUpViews() {
        addSubview(postLabel)
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        let inset: CGFloat = 10
        NSLayoutConstraint.activate([
            postLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            postLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            postLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            postLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
        postLabel.font = .preferredFont(forTextStyle: .body)
        postLabel.adjustsFontForContentSizeCategory = true
        postLabel.numberOfLines = 0
    }

    private func updateViews() {
        postLabel.text = post.link_text
    }
}
