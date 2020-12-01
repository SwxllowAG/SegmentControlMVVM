//
//  SegmentCell.swift
//  Test
//
//  Created by Galym Anuarbek on 10/18/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import UIKit
import SnapKit

class SegmentCell: UICollectionViewCell {
    
    var willBeginDragging: (() -> Void)?
    
    var tracks: [Track] = [] {
        didSet {
            selectedIndexPath = nil
            tracksTableView.reloadData()
        }
    }
    
    var selectedIndexPath: IndexPath?
    
    var tracksTableView: UITableView = {
        let tv = UITableView()
        tv.register(TracksCell.self, forCellReuseIdentifier: "cell")
        tv.backgroundColor = .clear
        tv.allowsMultipleSelection = true
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        setupDelegates()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: Configure subviews
extension SegmentCell {
    private func setupViews() {
        addSubview(tracksTableView)
    }
    
    private func setupConstraints() {
        tracksTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDelegates() {
        tracksTableView.dataSource = self
        tracksTableView.delegate = self
    }
}

// MARK: UITableView data source and delegate
extension SegmentCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TracksCell
        cell.track = tracks[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return tableView.frame.height
        } else {
            return 64
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        willBeginDragging?()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        tableView.performBatchUpdates(nil, completion: { _ in
            tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        })
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        (tableView.cellForRow(at: indexPath) as? TracksCell)?.animateIn()
        tableView.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        self.selectedIndexPath = nil
        tableView.performBatchUpdates(nil, completion: nil)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        (tableView.cellForRow(at: indexPath) as? TracksCell)?.animateOut()
        tableView.isScrollEnabled = true
    }
}
