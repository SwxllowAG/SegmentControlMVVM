//
//  TrackViewController.swift
//  Test
//
//  Created by Galym Anuarbek on 10/18/20.
//  Copyright © 2020 Galym Anuarbek. All rights reserved.
//

import UIKit
import SnapKit

class TrackViewController: UIViewController {
    
    static var segments = ["ITunes", "LastFM"]
    
    let viewModel = TrackViewModel()
    
    let segmentedControl = UISegmentedControl(items: segments)
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.barStyle = .black
        return sb
    }()
    
    var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    lazy var segmentsCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.showsHorizontalScrollIndicator = false
        cv.register(SegmentCell.self, forCellWithReuseIdentifier: "cell")
        cv.isPagingEnabled = true
        cv.bounces = true
        cv.allowsMultipleSelection = true
        cv.backgroundColor = .clear
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareViewModelObserview()
        setupViews()
        setupConstraints()
        setupDelegates()
    }
}

// MARK: Configure subviews
extension TrackViewController {
    private func setupViews() {
        navigationController?.navigationBar.barTintColor = .darkBar
        navigationController?.navigationBar.isTranslucent = false
        
        segmentedControl.selectedSegmentIndex = 0
        navigationItem.titleView = segmentedControl
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = UIColor.lightGray
        } else {
            segmentedControl.tintColor = UIColor.lightGray
        }
        segmentedControl.addTarget(self, action: #selector(segmentDidChange), for: .valueChanged)
        
        view.addSubview(searchBar)
        view.addSubview(segmentsCollectionView)
        view.backgroundColor = .black
    }
    
    private func setupConstraints() {
        searchBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(56)
        }
        segmentsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setupDelegates() {
        segmentsCollectionView.dataSource = self
        segmentsCollectionView.delegate = self
        searchBar.delegate = self
    }
}

// MARK: Action
extension TrackViewController {
    @objc func segmentDidChange() {
        segmentsCollectionView.scrollToItem(at: IndexPath(row: segmentedControl.selectedSegmentIndex, section: 0),
                                            at: .centeredHorizontally, animated: true)
    }
}

// MARK: Configure ViewModel
extension TrackViewController {
    func searchTracks(text: String) {
        viewModel.searchTracks(text: text)
    }
    
    func prepareViewModelObserview() {
        self.viewModel.itunesTrackDidChange = { _ in
            DispatchQueue.main.async {
                self.segmentsCollectionView.reloadItems(at: [IndexPath(row: 0, section: 0)])
            }
        }
        
        self.viewModel.lastFMTrackDidChange = { _ in
            DispatchQueue.main.async {
                self.segmentsCollectionView.reloadItems(at: [IndexPath(row: 1, section: 0)])
            }
        }
        
        self.viewModel.itunesSearchError = { (error) in
            self.presentAlert(title: "ITunes error", text: error?.localizedDescription ?? "Undefined error")
        }
        
        self.viewModel.lastFMSearchError = { (error) in
            self.presentAlert(title: "LastFM error", text: error?.localizedDescription ?? "Undefined error")
        }
    }
    
    func presentAlert(title: String, text: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: text, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: UICollectionView data source and delegate
extension TrackViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SegmentCell
        cell.tracks = indexPath.row == 0 ? viewModel.itunesTracks : viewModel.lastfmTracks
        cell.willBeginDragging = {
            self.searchBar.resignFirstResponder()
        }
        return cell
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let ix = Int(targetContentOffset.pointee.x/segmentsCollectionView.frame.width)
        if ix >= 2 || ix < 0 { return }
        segmentedControl.selectedSegmentIndex = ix
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }
}

// MARK: UISearchBar delegate
extension TrackViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text != nil && !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            searchTracks(text: searchBar.text!)
        }
    }
}
