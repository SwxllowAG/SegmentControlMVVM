//
//  TrackCells.swift
//  Test
//
//  Created by Galym Anuarbek on 10/18/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import UIKit
import SnapKit

class TracksCell: UITableViewCell {
    var track: Track? {
        didSet {
            titleLabel.text = track?.title
            subtitleLabel.text = track?.subtitle
            setThumbFrom(url: track?.thumbURL)
        }
    }
    
    var thumbView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 4
        return iv
    }()
    
    var titleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.font = UIFont.systemFont(ofSize: 16)
        return l
    }()
    
    var subtitleLabel: UILabel = {
        let l = UILabel()
        l.textColor = .lightGray
        l.font = UIFont.systemFont(ofSize: 13)
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Configure subviews
extension TracksCell {
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        addSubview(thumbView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    private func setupConstraints() {
        thumbView.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(thumbView.snp.right).offset(17)
            make.right.equalTo(-17)
            make.bottom.equalTo(thumbView.snp.centerY).offset(-2)
        }
        subtitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(thumbView.snp.right).offset(17)
            make.right.equalTo(-17)
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
    }
}

// MARK: Load thumb
extension TracksCell {
    func setThumbFrom(url: String?) {
        thumbView.image = nil
        if let url = url {
            thumbView.showSpinner()
            ImageLoader.loadImage(from: url, responseHandler: { (image) in
                self.thumbView.removeSpinner()
                DispatchQueue.main.async {
                    self.thumbView.image = image
                }
            }, errorHandler: { (error) in
                self.thumbView.removeSpinner()
                DispatchQueue.main.async {
                    self.thumbView.image = UIImage(named: "defaultThumb")
                }
            })
        } else {
            DispatchQueue.main.async {
                self.thumbView.image = UIImage(named: "defaultThumb")
            }
        }
    }
}

// MARK: Animations
extension TracksCell {
    func animateIn() {
        let scaleTransform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        self.thumbView.snp.remakeConstraints { (make) in
            make.width.equalTo(self.frame.width)
            make.height.equalTo(self.frame.height)
        }
        self.titleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-70)
        }
        self.subtitleLabel.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
        }
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.transform = scaleTransform
            self.subtitleLabel.transform = scaleTransform
            self.layoutIfNeeded()
        }
    }
    
    func animateOut() {
        self.thumbView.snp.remakeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(48)
        }
        self.titleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.thumbView.snp.right).offset(17)
            make.right.equalTo(-17)
            make.bottom.equalTo(self.thumbView.snp.centerY).offset(-2)
        }
        self.subtitleLabel.snp.remakeConstraints { (make) in
            make.left.equalTo(self.thumbView.snp.right).offset(17)
            make.right.equalTo(-17)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(4)
        }
        UIView.animate(withDuration: 0.3) {
            self.titleLabel.transform = .identity
            self.subtitleLabel.transform = .identity
            self.layoutIfNeeded()
        }
    }
}
