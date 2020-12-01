//
//  GSFeedViewController.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 26/11/20.
//

import UIKit
import GiphyUISDK
import GiphyCoreSDK
import RxSwift
import FLAnimatedImage
import RxCocoa
import Combine

/// GSFeedViewController - To show the list of Gifs
class GSFeedViewController: UIViewController, UITableViewDelegate {

    /// To add subcriptions to avoid memory leaks
    private let bag = DisposeBag()

    /// ViewModel instance
    private let gifViewModel = GifViewModel()

    let gifCellIdentifier = "gifIdentifier"

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var gifSearchBar: UISearchBar!
    @IBOutlet weak var feedTableView: UITableView!

    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        feedTableView.rx.setDelegate(self).disposed(by: bag)
        feedTableView.rowHeight = 140

        activityIndicator.startAnimating()
        getTrendingGifs()
    }

    /// Get Trending Gifs
    func getTrendingGifs() {
        bindTableViewData()
        gifViewModel.fetchTredingGifs()
    }

    /// Get Search Gifs
    /// - Parameter userQuery: String
    func getSearchedGifs(userQuery: String) {
        activityIndicator.startAnimating()
        gifViewModel.fetchSearchGifs(query: userQuery)
    }

    /// Bind Model to Table view cells
    private func bindTableViewData() {
        gifViewModel.gifs.bind(to: feedTableView.rx.items(cellIdentifier: gifCellIdentifier, cellType: GifFeedTableViewCell.self)) { (row, model, cell) in
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()

                    }
                    cell.cellDelegate = self
                    cell.favoriteButton.tag = row
                    cell.configure(with: model)
                }.disposed(by: bag)
    }
}

extension GSFeedViewController: GifFeedTableViewCellDelegate {
    func didPressFavoriteButton(tag: Int, model: GifModel, isAlreadyFavorite: Bool) {
        if isAlreadyFavorite {

            guard let id = model.id else {
                return
            }

            GSDBManager.sharedGifDBManager.getGifDao().deleteGifById(id: id)
            self.feedTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .automatic)
        } else {
            //Store Favorite gif intoDB
            GSDBManager.sharedGifDBManager.getGifDao().insert(obj: model)
            self.feedTableView.reloadRows(at: [IndexPath(row: tag, section: 0)], with: .automatic)
        }
    }
}

extension GSFeedViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Fetch searched gifs from
        if let enteredText = searchBar.text {
            getSearchedGifs(userQuery: enteredText)
        }

        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            searchBar.text = ""
            searchBar.resignFirstResponder()
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
}

