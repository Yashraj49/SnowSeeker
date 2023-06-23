//
//  Bundle-Decodable.swift
//  SnowSeeker
//
//  Created by Yashraj jadhav on 23/06/23.
//
import SwiftUI
import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file : String) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
            
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load data from \(file) bundle")
        }
        
        let decoder = JSONDecoder()
        
        guard let lodaded = try? decoder.decode(T.self, from: data) else
        {
            fatalError("Failed to decode \(file) from bundle")
            
        }
        return lodaded
    }
}
