//
//  MovieGridCell+TestHelpers.swift
//  MovieFlixAppTests
//
//  Created by Karina Piloupas on 18/05/25.
//

import Foundation
import UIKit
@testable import MovieFlixApp

#if DEBUG
extension MovieGridCell {
    /// Triggers the favorite action callback (used for testing)
    func triggerFavoriteAction(from view: UIViewController? = nil) {
        favoriteAction?()
    }
}
#endif
