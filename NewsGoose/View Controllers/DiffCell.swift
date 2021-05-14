//
//  DiffCell.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/10/21.
//

import UIKit
import NGCore
import SnapKit

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
        postLabel.font = .preferredFont(forTextStyle: .body)
        postLabel.adjustsFontForContentSizeCategory = true
        postLabel.numberOfLines = 0
        addSubview(postLabel)
        postLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }

    private func updateViews() {
        postLabel.text = post.link_text
    }
}
