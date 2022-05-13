//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Abdullah Al Sohel on 5/12/22.
//

import UIKit

extension String {
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}

