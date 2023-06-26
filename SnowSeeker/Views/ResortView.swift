//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Yashraj jadhav on 23/06/23.
//

import SwiftUI

struct ResortView: View {
    let resort: Resort

    @Environment(\.horizontalSizeClass) var sizeClass
    @Environment(\.dynamicTypeSize) var typeSize

    @EnvironmentObject var favorites: Favorites

    @State private var selectedFacility: Facility?
    @State private var showingFacility = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(decorative: resort.id)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 400)
                    .frame(maxHeight: 410)
                    .cornerRadius(50)
                    .shadow(radius: 10)
                    
                    .overlay(
                        VStack{
                            Spacer()
                            Text("Image Credit: \(resort.imageCredit)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.bottom, 8)
                                .background(Color.black.opacity(0.7))
                                .cornerRadius(8)
                        }
                        .padding(.bottom, 2)
                        , alignment: .bottom)

                HStack {
                    if sizeClass == .compact && typeSize > .large {
                        VStack(spacing: 10) {
                            ResortDetailsView(resort: resort)
                        }
                        VStack(spacing: 10) {
                            SkiDetailsView(resort: resort)
                        }
                    } else {
                        ResortDetailsView(resort: resort)
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(Color.primary.opacity(0.1))
                .cornerRadius(10)

                Group {
                    Text(resort.description)
                       
                       // .padding(.vertical)

                    Text("Facilities")
                        .font(.headline)
                        .padding(.bottom, 4)

                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button(action: {
                                selectedFacility = facility
                                showingFacility = true
                            }) {
                                facility.icon
                                    .font(.title)
                                    .padding(8)
                                    //.background(Color.accentColor)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    .padding(.vertical, 4)

                    Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                        if favorites.contains(resort) {
                            favorites.remove(resort)
                        } else {
                            favorites.add(resort)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding()

                    Spacer()
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        .alert(item: $selectedFacility) { facility in
            Alert(
                title: Text(facility.name),
                message: Text(facility.description),
                dismissButton: .default(Text("Close"))
            )
        }
    }
}


struct ResortView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ResortView(resort: Resort.example)
        }
        .environmentObject(Favorites())
    }
}
