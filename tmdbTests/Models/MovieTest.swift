//
//  MovieTest.swift
//  tmdbTests
//
//  Created by Patrik Qvarnström on 2019-07-08.
//  Copyright © 2019 Patrik Qvarnström. All rights reserved.
//

import XCTest
@testable import tmdb

class MovieTest: XCTestCase {

    private var models: [Movie]!

    func testDecodeMovie() {
        loadModelFrom(jsonFile: "movie.json")
        XCTAssertEqual(models[0].adult, false)
        XCTAssertEqual(models[0].id, 550)
        XCTAssertEqual(models[0].backdropPath, "/fCayJrkfRaCRCTh8GqN30f8oyQF.jpg")
        XCTAssertEqual(models[0].genres[0].name, "Drama")
        XCTAssertEqual(models[0].originalTitle, "Fight Club")
        XCTAssertEqual(models[0].overview, "A ticking-time-bomb insomniac and a slippery soap salesman channel primal male aggression into a shocking new form of therapy. Their concept catches on, with underground \"fight clubs\" forming in every town, until an eccentric gets in the way and ignites an out-of-control spiral toward oblivion.")
        XCTAssertEqual(models[0].releaseDate, "1999-10-12")
    }

    func loadModelFrom(jsonFile: String) {
        do {
            models = try JSONDecoder().decode([Movie].self, from: getJsonFrom(filename: jsonFile))
        } catch {
            print(error)
        }
    }

    func getJsonFrom(filename: String) -> Data {
        guard let path = Bundle.main.path(forResource: filename, ofType: nil) else {
            XCTFail("JSON file could not be found: \(filename)")
            fatalError()
        }

        do {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .dataReadingMapped)
        } catch {
            XCTFail("An error was thrown: \(error)")
            fatalError()
        }
    }

}
