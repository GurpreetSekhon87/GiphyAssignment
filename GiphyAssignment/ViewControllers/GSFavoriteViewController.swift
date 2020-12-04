//
//  GSFavoriteViewController.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 26/11/20.
//

import UIKit
import RxSwift
import os

class GSFavoriteViewController: UIViewController, UICollectionViewDelegate {

    /// To add subcriptions to avoid memory leaks
    private let bag = DisposeBag()
    var favoritesGif: [GifModel] = []
    let gifFavoriteCellIdentifier = "gifFavoriteCellIdentifier"
    private let gifViewModel = GifViewModel()

    @IBOutlet weak var favoriteGifsCollectionView: UICollectionView!
    @IBOutlet weak var placeHolderLabel: UILabel!

    /// viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        favoriteGifsCollectionView.rx.setDelegate(self).disposed(by: bag)
        bindCollectionViewForGifs()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadLocalGifs()
    }

    /// Bind data to collection view items
    private func bindCollectionViewForGifs() {
        gifViewModel.gifs.bind(to: favoriteGifsCollectionView.rx.items(cellIdentifier: gifFavoriteCellIdentifier, cellType: FavoriteGifCollectionViewCell.self)) { (row, model, cell) in
                    cell.cellDelegate = self
                    cell.unFavoriteButton.tag = row
                    cell.configure(with: model)
        }.disposed(by: bag)
    }

    /// To fetch Gifs from local storage
    public func loadLocalGifs() {
        gifViewModel.fetchSavedGifs().subscribe { gifModels in
            self.gifViewModel.gifs.accept(gifModels)
            self.favoritesGif = gifModels
            self.updatePlaceholderLabel()
        } onError: { error in
            os_log("Error in loadig saved gifs")
        } onCompleted: {
            os_log("fetchSavedGifs - Completed")
        } onDisposed: {
            os_log("fetchSavedGifs - Disposed")
        }.dispose()
    }

    /// To update the placeholder label
    public func updatePlaceholderLabel() {
        if favoritesGif.isEmpty {
            placeHolderLabel.isHidden = false
        } else {
            placeHolderLabel.isHidden = true
        }
    }

    /// deinit
    deinit {
        print("Deinit called for GSFavoriteVC")
    }
}

// GSFavoriteViewController extension for FavoriteGifCollectionViewCellDelegate
extension GSFavoriteViewController: FavoriteGifCollectionViewCellDelegate {
    func didPressUnFavoriteButton(tag: Int) {

        guard let id = self.favoritesGif[tag].id else {
            return
        }

        if gifViewModel.deleteGifFromDatabase(id: id) {
            loadLocalGifs()
        }
    }
}
