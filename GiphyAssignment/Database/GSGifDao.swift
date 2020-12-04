//
//  GSGIfDao.swift
//  GiphyAssignment
//
//  Created by Gurpreet Singh on 27/11/20.
//

import Foundation
import GRDB
import os
import RxSwift

public class GSGifDao {
    private var disposeBag = DisposeBag()

    @discardableResult public func insert<T>(obj: T) -> Bool {
        if let gif = (obj as? GifModel) {
            return insertDataIntoGifTable(gif: gif)
        }
        return false
    }

    public func delete<T>(obj: T) {
        if let gifId = (obj as? String) {
            deleteGifById(id: gifId)
        }
    }

    /// Truncate GifModel
    ///
    /// - Parameter obj: Generic
    public func truncateTable() {
        deleteAllRecords()
    }

    // Delete from GifModel
    func deleteAllRecords() {
        do {
            try sharedDBPool.writeInTransaction { db in
                try GifModel.deleteAll(db)
                return .commit
            }
        } catch {
            os_log("****************** Gif Model Truncate ERROR ******************")
            os_log("Table Truncate - Error")
        }
    }

    /// To Insert data into Table
    /// - Parameter gif: Gif Model
    /// - Returns: Returns the Bool value - True if successful
    func insertDataIntoGifTable(gif: GifModel) -> Bool {
        let request = GifModel.all()
        request.rx.changes(in: sharedDBPool)
            .subscribe(onNext: { _ in
                os_log("Inserted into Gif table")
            }, onCompleted: {
                os_log("Operation Completed.")
            }).disposed(by: self.disposeBag)

        do {
            try sharedDBPool.writeInTransaction { db in
                var dbGif = gif
                try dbGif.insert(db)
                return .commit
            }
            return true
        } catch {
            os_log("Insertion Failed")
            return false
        }
    }

    /// Load
    /// - Parameter id: <#id description#>
    /// - Returns: <#description#>
    func loadById(id: String) -> GifModel? {
        let request = GifModel.filter(key: ["id": id])
        var gif: GifModel?
        do {
            try sharedDBPool.writeInTransaction { db in
                gif = try GifModel.fetchOne(db, request)
                return .commit
            }
        } catch {
            os_log("loadById operation Failed")
        }
        return gif
    }

    @discardableResult func loadByIdRx(id: String) -> Observable<[GifModel]> {
        let request = GifModel.filter(Column("id") == id)
        return request.rx.observeAll(in: sharedDBPool)
    }

    /// Load all Gifs
    /// - Returns: Array of Gif Models
    func loadAllGifs() -> [GifModel] {
        var gifs = [GifModel]()
        do {
            try sharedDBPool.writeInTransaction { db in
                gifs = try GifModel.fetchAll(db)
                return .commit
            }
        } catch {
            os_log("Load all Gifs - Error")
        }

        return gifs
    }

    /// Load all Gifs Rx
    /// - Returns: Observable of Array of Gif Models
    func loadAllGifsRx() -> Observable<[GifModel]> {
        let request = GifModel.all()
        return request.rx.observeAll(in: sharedDBPool)
    }

    // Delete Gif from DB
    func deleteGifById(id: String) -> Bool {
        do {
            try sharedDBPool.writeInTransaction { db in
                try GifModel.deleteOne(db, key: id)
                return .commit
            }
            return true
        } catch {
            os_log("Delete Gif By Id - Error")
            return false
        }
    }
}
