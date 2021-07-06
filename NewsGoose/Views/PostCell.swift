//
//  PostCell.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/10/21.
//

import UIKit
import NGCore
import SnapKit

protocol PostCellDelegate {
    func showComments(for post: Post)
}

class PostCell: UICollectionViewCell {

    var post: Post! {
        didSet {
            updateViews()
        }
    }
    var delegate: PostCellDelegate!

    private let pointsLabel = UILabel()
    private let linkTextLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        NotificationCenter.default.addObserver(self, selector: #selector(clearHighlight(_:)), name: .backToAppFromSafariVC, object: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Highlight

    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                backgroundColor = .cellHighlight
            } else {
                backgroundColor = .cellBackground
            }
        }
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .cellHighlight
            }
            // `backgroundColor` resets in function below
        }
    }

    @objc private func clearHighlight(_ notification: Notification) {
        guard let selectedPost = notification.userInfo?["selectedPost"] as? Post else { preconditionFailure("no post") }

        if self.post == selectedPost {
            backgroundColor = .cellHighlight
            UIView.animate(withDuration: 2, delay: 0, options: [.allowUserInteraction]) {
                self.backgroundColor = .cellRecentHighlight
            }
        } else {
            backgroundColor = .cellBackground
        }
    }

    // MARK: - View Setup

    private func setUpViews() {

        let pointsFont = UIFont.preferredFont(forTextStyle: .caption2)
        let pointsAdjustSize = true

        let pointsMaxWidthLabel = UILabel()
        pointsMaxWidthLabel.text = "9999"
        pointsMaxWidthLabel.font = pointsFont
        pointsMaxWidthLabel.adjustsFontForContentSizeCategory = pointsAdjustSize
        pointsMaxWidthLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        pointsMaxWidthLabel.isHidden = true
        addSubview(pointsMaxWidthLabel)
        pointsMaxWidthLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(1)
            make.top.bottom.equalToSuperview().inset(10)
        }

        pointsLabel.font = pointsFont
        pointsLabel.adjustsFontForContentSizeCategory = pointsAdjustSize
        pointsLabel.textAlignment = .right
        pointsLabel.textColor = .systemGray
        addSubview(pointsLabel)
        pointsLabel.snp.makeConstraints { make in
            make.edges.equalTo(pointsMaxWidthLabel)
        }

        linkTextLabel.font = .preferredFont(forTextStyle: .body)
        linkTextLabel.adjustsFontForContentSizeCategory = true
        linkTextLabel.numberOfLines = 0
        addSubview(linkTextLabel)
        linkTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(pointsLabel.snp.trailing).offset(10)
            make.height.greaterThanOrEqualTo(36)
            make.top.bottom.equalToSuperview().inset(10)
        }

        let commentsButton = UIButton(type: .custom)
        commentsButton.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        commentsButton.addTarget(self, action: #selector(showComments(_:)), for: .touchUpInside)
        addSubview(commentsButton)
        commentsButton.snp.makeConstraints { make in
            make.leading.equalTo(linkTextLabel.snp.trailing).offset(2)
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(4)
            make.width.equalTo(44)
        }
    }

    // MARK: - View Udates

    override func prepareForReuse() {
        super.prepareForReuse()
        linkTextLabel.textColor = .linkTextUnread
        backgroundColor = .cellBackground
    }

    func updateViews() {
        pointsLabel.text = "\(post.points ?? 0)"
        linkTextLabel.text = post.link_text

        linkTextLabel.textColor = UserDefaults.postBeenRead(post.id) ? .linkTextRead : .linkTextUnread
    }

    // MARK: - Actions

    @objc func showComments(_ sender: UIButton) {
        delegate.showComments(for: post)
    }
}
