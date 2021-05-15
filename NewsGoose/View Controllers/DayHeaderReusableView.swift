//
//  DayHeaderReusableView.swift
//  NewsGoose
//
//  Created by Chad Parker on 5/13/21.
//

import UIKit
import SnapKit

class DayHeaderReusableView: UICollectionReusableView {

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

        let orangeColor = UIColor(red: 1.00, green: 0.40, blue: 0.00, alpha: 1.00)

        let cover = UIView()
        cover.backgroundColor = .systemBackground
        addSubview(cover)
        cover.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(snp.centerY)
        }

        let horizontalLine = UIView()
        horizontalLine.backgroundColor = orangeColor
        addSubview(horizontalLine)
        horizontalLine.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }

        let labelBackground = UIView()
        labelBackground.backgroundColor = orangeColor
        labelBackground.layer.cornerRadius = 4
        labelBackground.layer.masksToBounds = true
        addSubview(labelBackground)
        labelBackground.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.trailing.equalToSuperview().inset(10)
            make.leading.greaterThanOrEqualTo(snp.leading)
        }

        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .systemBackground
        dateLabel.adjustsFontForContentSizeCategory = true
        dateLabel.textAlignment = .right
        dateLabel.numberOfLines = 0 // for accessibility sizes
        labelBackground.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
    }

    private func updateViews() {
        dateLabel.text = DateFormatter.fullDate.string(from: date)
    }
}
