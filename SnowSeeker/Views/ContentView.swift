//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Yashraj jadhav on 21/06/23.
//

import SwiftUI

extension View {
    @ViewBuilder func phoneOnlyNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")

    @StateObject var favorites = Favorites()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List(filteredResorts) { resort in
                NavigationLink {
                    ResortView(resort: resort)
                } label: {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )

                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundColor(.secondary)
                        }

                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                                .accessibilityLabel("This is a favorite resort")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            favorites.sortingOption = .default
                        }) {
                            Text("Default")
                            if favorites.sortingOption == .default {
                                Image(systemName: "checkmark")
                            }
                        }

                        Button(action: {
                            favorites.sortingOption = .alphabetical
                        }) {
                            Text("Alphabetical")
                            if favorites.sortingOption == .alphabetical {
                                Image(systemName: "checkmark")
                            }
                        }

                        Button(action: {
                            favorites.sortingOption = .country
                        }) {
                            Text("Country")
                            if favorites.sortingOption == .country {
                                Image(systemName: "checkmark")
                            }
                        }
                    } label: {
                        Label("Sort By", systemImage: "arrow.up.arrow.down")
                    }
                }
            }

            WelcomeView()
        }
        .environmentObject(favorites)
    }

    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            return resorts
        } else {
            return resorts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
