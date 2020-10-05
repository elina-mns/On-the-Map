//
//  OpeningSafari.swift
//  On the Map
//
//  Created by Elina Mansurova on 2020-10-05.
//

import UIKit

struct OpeningSafari {
    
    let enteredLink: String
    
    func canOpenURL(_ url: URL) -> Bool {
        UIApplication.shared.canOpenURL(url)
    }
    
    func open() {
        guard let url = URL(string: enteredLink) else { return }
        guard canOpenURL(url) else { return }
        UIApplication.shared.open(url)
    }

}
