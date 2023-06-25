//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Yashraj jadhav on 24/06/23.
//

import SwiftUI



enum ResortSortingOption {
    case `default`
    case alphabetical
    case country
}



class Favorites: ObservableObject {
    
    @Published var resortsX: [Resort] = []
    @Published var sortingOption: ResortSortingOption = .default
    
    // the actual resorts the user has favorited
    @Published private var resorts: Set<String>

    // the key we're using to read/write in UserDefaults
    private let saveKey = "Favorites"

    init() {
        // load our saved data
        if let savedResorts = UserDefaults.standard.stringArray(forKey: saveKey) {
            resorts = Set(savedResorts)
        } else {
            resorts = []
        }
        resortsX = []
    }
    
    var sortedResorts: [Resort] {
            switch sortingOption {
            case .default:
                return resortsX
            case .alphabetical:
                return resortsX.sorted { $0.name < $1.name }
            case .country:
                return resortsX.sorted { $0.country < $1.country }
            }
        }

    // returns true if our set contains this resort
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    // adds the resort to our set, updates all views, and saves the change
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }

    // removes the resort from our set, updates all views, and saves the change
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }

    func save() {
        UserDefaults.standard.set(Array(resorts), forKey: saveKey)
    }
}

