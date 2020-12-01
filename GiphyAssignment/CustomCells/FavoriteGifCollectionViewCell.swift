//
//  FavoriteGifCollectionViewCell.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 27/11/20.
//

import UIKit
import FLAnimatedImage

/// FavoriteGifCollectionViewCellDelegate to handle user action
protocol FavoriteGifCollectionViewCellDelegate : class {
    func didPressUnFavoriteButton(tag: Int)
}

/// FavoriteGifCollectionViewCell
class FavoriteGifCollectionViewCell: UICollectionViewCell {

    var cellDelegate: FavoriteGifCollectionViewCellDelegate?

    @IBOutlet weak var unFavoriteButton: UIButton!
    @IBOutlet weak var favoriteGifImageView: FLAnimatedImageView!

    /// To configure data for collection view cell
    /// - Parameter model: Gif Model
    public func configure(with model: GifModel) {

        let downsizedObj = model.images?.filter { key, value in
            return key == "downsized"
        }

        guard let imageObj = downsizedObj["downsized"] as? [String: String] else {
            return
        }

        guard let url = imageObj["url"] else {
            return
        }

        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string: url)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

            DispatchQueue.main.async {
                if let data = data {
                    self.favoriteGifImageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
                }
            }
        }
    }

    /// Action when user click on the unfavorite Button
    /// - Parameter sender: Button
    @IBAction func unFavoriteButtonAction(_ sender: UIButton) {
        cellDelegate?.didPressUnFavoriteButton(tag: sender.tag)
    }
}
