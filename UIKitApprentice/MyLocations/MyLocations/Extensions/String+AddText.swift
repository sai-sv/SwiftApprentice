//
//  String+AddText.swift
//  MyLocations
//
//  Created by Sergei Sai on 06.02.2022.
//

import Foundation

extension String {
    
    mutating func add(text: String?, separatedBy separator: String = "") {
        if let text = text {
            if !isEmpty {
                self += separator
            }
            self += text
        }
    }
}
