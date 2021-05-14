//
//  DateHeaderReusableView.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/13/21.
//

import UIKit

class DateHeaderReusableView: UICollectionReusableView {

    var date: Date! {
        didSet {
            updateViews()
        }
    }

    private let dateLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setUpViews() {
        backgroundColor = .systemBackground
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        let inset: CGFloat = 10
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
        ])
        dateLabel.font = .preferredFont(forTextStyle: .callout)
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.textAlignment = .right
        dateLabel.numberOfLines = 0 // accessibility
    }

    private func updateViews() {
        dateLabel.text = DateFormatter.fullDate.string(from: date)
    }
}
