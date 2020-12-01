//
//  GSFavoriteGifsTest.swift
//  GiphyAssignmentTests
//
//  Created by Gurpreet Singh on 28/11/20.
//

import Quick
import Nimble
import RxSwift
import XCTest
import RxBlocking
import os

@testable import GiphyAssignment

class GSFavoriteGifsTest: QuickSpec {

    var gif: GifModel!

    var favoriteGifs: [GifModel]?
    var gsFavoriteVC: GSFavoriteViewController?

    let getGif = { (id: String) in
        GSDBManager.sharedGifDBManager.getGifDao().loadById(id: id)
    }

    func generateGifTestModel() -> GifModel {
        let gifModel = GifModel()
        gifModel.id = UUID().uuidString
        gifModel.images = nil
        gifModel.type = "gif"
        gifModel.url = "Gif Url"

        return gifModel
    }

    override func spec(){

        beforeEach{
            GSDBManager.sharedGifDBManager.getGifDao().truncateTable()
            self.gif = self.generateGifTestModel()
        }

        describe("GSFavoriteViewController"){
            it("Test loading View Controller and Table View"){

                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let tabController = storyboard.instantiateViewController(identifier: "TabBarController") as? UITabBarController

                guard let viewController = tabController?.viewControllers?.last as? GSFavoriteViewController else {
                    return XCTFail("Could not instantiate GSFavoriteViewController from main storyboard")
                }

                viewController.loadViewIfNeeded()

                self.gsFavoriteVC = viewController

                expect(viewController.favoriteGifsCollectionView).toNot(beNil())

            }
        }

        describe("Database Creation") {
            context("When application start") {
                it("should create the database") {

                    let _ = GSDBManager.sharedGifDBManager

                    //Database path
                    let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
                    let databasePath = documentsPath.appendingPathComponent(giphyDB)

                    expect(FileManager.default.fileExists(atPath: databasePath)).toEventually(beTrue())
                }
            }
        }

        describe("GifDao") {
            context("DB Operations") {
                it("can insert, delete and load GifModel") {
                    let isInsertedSuccessfully =  GSDBManager.sharedGifDBManager.getGifDao().insert(obj: self.gif)
                    expect(isInsertedSuccessfully).to(equal(true))
                }

                it("try load a nonexistent gif"){
                    expect(self.getGif("xyz")).to(beNil())
                }

                it("should load the data from GifModel Table") {
                    let gifs = [self.generateGifTestModel(), self.generateGifTestModel()]

                    GSDBManager.sharedGifDBManager.getGifDao().insert(obj: gifs[0])
                    GSDBManager.sharedGifDBManager.getGifDao().insert(obj: gifs[1])

                    // wait to complete insert
                    expect(self.getGif(gifs[0].id!)).toEventuallyNot(beNil(), timeout: 3)
                    expect(self.getGif(gifs[1].id!)).toEventuallyNot(beNil(), timeout: 3)

                    /// case 1
                    let getAllGifs = { GSDBManager.sharedGifDBManager.getGifDao().loadAllGifs() }
                    expect(getAllGifs().count).to(equal(2))

                    self.gsFavoriteVC?.loadLocalGifs()

                    expect(self.gsFavoriteVC?.placeHolderLabel.isHidden).to(equal(true))


                    /// case 2
                    do {
                        let loadedGifs = try GSDBManager.sharedGifDBManager.getGifDao().loadAllGifsRx().toBlocking().first()
                        expect(loadedGifs?.count).to(equal(2))
                    } catch {
                        os_log("Error in loading Rx Gifs")
                    }
                }

                it("can delete Gif record"){
                    /// insert
                    GSDBManager.sharedGifDBManager.getGifDao().insert(obj: self.gif)
                    expect(self.getGif(self.gif.id!)).toEventuallyNot(beNil(), timeout: 3)

                    /// delete
                    GSDBManager.sharedGifDBManager.getGifDao().delete(obj: self.gif.id)
                    expect(self.getGif(self.gif.id!)).toEventually(beNil(), timeout: 3)
                }
            }
        }
    }
}
