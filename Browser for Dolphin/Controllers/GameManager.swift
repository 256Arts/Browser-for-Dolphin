//
//  GameManager.swift
//  Browser for Dolphin
//
//  Created by 256 Arts Developer on 2022-11-06.
//

import Foundation
import RegexBuilder

final class GameManager {
    
    static let dolphinCacheDirectoryURL: URL = {
        guard let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first else { fatalError("Cannot access directory") }
        return appSupport.appending(path: "Dolphin", directoryHint: .isDirectory).appending(path: "Cache", directoryHint: .isDirectory)
    }()
    static var coversDirectoryURL: URL {
        dolphinCacheDirectoryURL.appending(path: "GameCovers", directoryHint: .isDirectory)
    }
    
    func loadGamesList() throws -> [Game] {
        let url = Self.dolphinCacheDirectoryURL.appending(path: "gamelist.cache", directoryHint: .notDirectory)
        let fullString = try String(contentsOf: url, encoding: .ascii)
        let uppercase = CharacterClass.generalCategory(.uppercaseLetter)
        
        let rangePattern = Regex {
            ":modify"
            OneOrMore(.any)
            "Zstandard"
        }
            .repetitionBehavior(.reluctant)
        
        let gameFilePath = Reference(Substring.self)
        let idRef = Reference(Substring.self)
        let gamePattern = Regex {
            ":modify"
            OneOrMore(.any)
            Capture(as: gameFilePath) {
                "/"
                OneOrMore(.any)
                ChoiceOf {
                    ".iso"
                    ".gcz"
                    ".wia"
                    ".rvz"
                }
            }
            OneOrMore(.any, .eager)
            Capture(as: idRef) {
                Repeat(uppercase.union(.digit), count: 6)
            }
            OneOrMore(.any)
            "Zstandard"
        }
            .repetitionBehavior(.reluctant)
        
        let gameMatches = fullString.matches(of: rangePattern)
            .filter { $0.output.contains(".iso") || $0.output.contains(".gcz") || $0.output.contains(".wia") || $0.output.contains(".rvz") }
            .compactMap {
                var rangeMatch = $0.output
                // Wii games not supported yet. Filter them out:
                while rangeMatch.contains(".wbfs") {
                    rangeMatch = rangeMatch
                        .suffix(from: rangeMatch.firstRange(of: ".wbfs")!.lowerBound)
                        .firstMatch(of: rangePattern)?
                        .output ?? ""
                }
                return rangeMatch.firstMatch(of: gamePattern)
            }
        
        #if DEBUG
        print("Games found:", gameMatches.count)
        for match in gameMatches {
            if match[idRef].first == "G" {
                print("✅", match[idRef], match[gameFilePath])
            } else {
                print("⚠️", match[idRef], match[gameFilePath])
                print("Full:", match.output.0)
            }
        }
        #endif
        
        return gameMatches
            .map({
                let id = String($0[idRef])
                let fileURL = URL(filePath: String($0[gameFilePath]), directoryHint: .notDirectory)
                var name = fileURL.deletingPathExtension().lastPathComponent
                let nameFirstBracketIndex = name.firstIndex(of: "(") ?? name.firstIndex(of: "[")
                if let nameFirstBracketIndex {
                    name = String(name.prefix(upTo: nameFirstBracketIndex))
                }
                return Game(id: id, name: name, fileURL: fileURL)
            })
            .sorted(by: { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending })
    }
    
}
