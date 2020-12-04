//
//  GSGifsFeedTests.swift
//  GiphyAssignmentTests
//
//  Created by Gurpreet Singh on 28/11/20.
//

import Quick
import Nimble
@testable import GiphyAssignment

class GSGifsFeedTests: QuickSpec {

    override func spec(){
        let networkManager = NetworkManager()

        describe("GSFeedViewController"){
            it("Test loading View Controller and Table View"){

                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let tabController = storyboard.instantiateViewController(identifier: "TabBarController") as? UITabBarController

                guard let viewController = tabController?.viewControllers?.first as? GSFeedViewController else {
                    return XCTFail("Could not instantiate GSFeedViewController from main storyboard")
                }

                viewController.loadViewIfNeeded()

                expect(viewController.feedTableView).toNot(beNil())

            }
        }

        describe("Network call is establised for Trending Gif API"){
            it("should get trending list"){
                waitUntil(timeout: 5) { done in
                    networkManager.getGifs(offset: 0) { gifModels, error in
                        expect(gifModels?.count).to(equal(4))
                        done()
                    }
                }
            }
        }

        describe("Network call is establised for Search Gif API"){
            it("should get list of gifs according to user input"){
                waitUntil(timeout: 5) { done in
                    networkManager.getGifs(query: "Burger", offset: 0) { gifModels, error in
                        expect(gifModels?.count).to(equal(4))
                        done()
                    }
                }
            }
        }

        func testControllerHasTableView() {
            guard let controller = UIStoryboard(name: "Main", bundle: Bundle(for: GSFeedViewController.self)).instantiateInitialViewController() as? GSFeedViewController else {
                return XCTFail("Could not instantiate GSFeedViewController from main storyboard")
            }

            controller.loadViewIfNeeded()

            XCTAssertNotNil(controller.feedTableView,
                            "Controller should have a tableview")
        }
    }
}
