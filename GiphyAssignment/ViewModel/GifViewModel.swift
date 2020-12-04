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
    func fetchTredingGifs(offset: Int) {
        networkManager?.getGifs(offset: offset) { gifModels, error in
                guard let gifs = gifModels else {
                    os_log("Error in loading trending gifs")
                    return
                }
                if offset == 0 {
                    self.gifs.accept(gifs)
                } else {
                    self.gifs.accept(self.gifs.value + gifs)

                }
        }
    }

    /// To fetch Gifs from Giphy API according to the user input
    /// - Parameter query: String
    func fetchSearchGifs(query: String, offset: Int) {
        networkManager?.getGifs(query: query, offset: offset) { gifModels, error in
            guard let gifs = gifModels else {
                os_log("Error in loading searched gifs")
                return
            }
            if offset == 0 {
                self.gifs.accept(gifs)
            } else {
                self.gifs.accept(self.gifs.value + gifs)
            }
        }
    }

    /// To Fetch the saved Gifs from local storage
    /// - Returns: It will return the Observable of Array of GifModel object
    func fetchSavedGifs() -> Observable<[GifModel]> {
        return GSDBManager.sharedGifDBManager.getGifDao().loadAllGifsRx()
    }

    /// To insert the data into database
    /// - Parameter gif: Gif Model
    /// - Returns: It will return true if insertion is successful
    func insertGifIntoDatabase(gif: GifModel) -> Bool {
       return GSDBManager.sharedGifDBManager.getGifDao().insert(obj: gif)
    }

    /// To Delete the data from database
    /// - Parameter id: Gif id
    /// - Returns: It will return true if deletion is successful
    func deleteGifFromDatabase(id: String) -> Bool {
       return GSDBManager.sharedGifDBManager.getGifDao().deleteGifById(id: id)
    }
}
