//
//   Extensions.swift
//  VuduTV
//
//  Created by Mcbook Pro on 05.09.22.
//

import Foundation

extension String {
    
    func capitalizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
   
}
