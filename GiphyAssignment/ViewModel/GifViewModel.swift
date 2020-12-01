//
//  GifViewModel.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 29/11/20.
//

import Foundation
import RxSwift
import RxCocoa
import os

/// GifViewModel for network and DB operations
class GifViewModel {

    /// Network Manager instance
    var networkManager: NetworkManager?

    /// Init constructor
    init() {
        self.networkManager = NetworkManager()
    }

    /// To hold array of gif models and to refresh table view/ collection view data whenever new data comes
    let gifs = BehaviorRelay(value: [GifModel]())

    /// To fetch Trending Gifs from Giphy API
    func fetchTredingGifs() {
        networkManager?.getTrendingGifs(page: 1) { gifModels, error in
                guard let gifs = gifModels else {
                    os_log("Error in loading trending gifs")
                    return
                }
                self.gifs.accept(gifs)
            }
    }

    /// To fetch Gifs from Giphy API according to the user input
    /// - Parameter query: String
    func fetchSearchGifs(query: String) {
        networkManager?.getSearchedGifs(query: query) { gifModels, error in
            guard let gifs = gifModels else {
                os_log("Error in loading searched gifs")
                return
            }
            self.gifs.accept(gifs)
        }
    }

    /// To Fetch the saved Gifs from local storage
    /// - Returns: It will return the Observable of Array of GifModel object
    func fetchSavedGifs() -> Observable<[GifModel]> {
        return GSDBManager.sharedGifDBManager.getGifDao().loadAllGifsRx()
    }
}
