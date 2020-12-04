//
//  GifFeedTableViewCell.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 26/11/20.
//

import UIKit
import FLAnimatedImage
import Kingfisher

/// GifFeedTableViewCellDelegate to handle user action
protocol GifFeedTableViewCellDelegate : class {
    func didPressFavoriteButton(tag: Int, model: GifModel, isAlreadyFavorite: Bool)
}

/// GifFeedTableViewCell
class GifFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var favoriteButton: UIButton!
    var cellDelegate: GifFeedTableViewCellDelegate?
    var localGifs: [GifModel]?
    var gif: GifModel?

    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// Action when user click on the favorite Button
    /// - Parameter sender: Button
    @IBAction func favoriteButtonAction(sender: UIButton) {
        // Add to Favorites
        if favoriteButton.titleLabel?.text == "Add to favorite" {
            cellDelegate?.didPressFavoriteButton(tag: sender.tag, model: self.gif!, isAlreadyFavorite: false)
        } else {
            cellDelegate?.didPressFavoriteButton(tag: sender.tag, model: self.gif!, isAlreadyFavorite: true)
        }
    }

    /// To configure data for Table view cell
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

        if checkifGifIsAlreadyFavorite(gif: model) {
            favoriteButton.setTitle("UnFavorite", for: .normal)
        } else {
            favoriteButton.setTitle("Add to favorite", for: .normal)
        }

        self.gif = model

        if let url = URL(string: url) {
            gifImageView.kf.indicatorType = .activity
            gifImageView.kf.setImage(with: url)
        }
    }

    /// To check whether Gif is already mark as favorite or not
    /// - Parameter gif: Gif Model
    /// - Returns: It will return Bool value
    private func checkifGifIsAlreadyFavorite(gif: GifModel) -> Bool {
        localGifs = GSDBManager.sharedGifDBManager.getGifDao().loadAllGifs()

        if let storedGifs = localGifs {
            let results = storedGifs.filter { $0.id == gif.id }
            return !results.isEmpty
        }
        return false
    }
}

