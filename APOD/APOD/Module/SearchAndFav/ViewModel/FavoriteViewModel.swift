//
//  FavoriteViewModel.swift
//  APOD
//
//  Created by Patel, Mohit on 11/08/22.
//

import Foundation
import UIKit
/// Protocol for communication between `FavoriteViewModel` and associated controller
protocol FavoriteViewModelDelegate: AnyObject {
    /**
     Method to notifiy did select event
     */
    func didSelectFavorite(objFav: Favorite)
    
    /**
     Method to reload table view
     */
    func reloadTableView()
    
    /**
     Method to reload table view
     - parameter isRecordFound: true if record found
     */
    func toggleNoRecordLabel(isRecordFound: Bool)
}

/// View model class for favorite pic
class FavoriteViewModel {
    /// delegate object of FavoriteViewModelDelegate
    weak var delegate: FavoriteViewModelDelegate?
    
    /// list of favorite objects
    var arrFavorite: [Favorite]?

    /**
     Function to fetch list of favorites
     */
    func fetchFavoritePictures() {
        arrFavorite = Favorite.fetchFavorites()
        delegate?.reloadTableView()
        if let arr = arrFavorite, arr.count > 0 {
            delegate?.toggleNoRecordLabel(isRecordFound: true)
        } else {
            delegate?.toggleNoRecordLabel(isRecordFound: false)
        }
    }
}
// MARK: Table View Data Provider methods
extension FavoriteViewModel {
    // MARK: Table View Data Provider methods
    
    /**
     Function to get number of rows
     - returns- number of rows
     */
    func getNumberOfRows(section: Int) -> Int {
        guard let arr = arrFavorite else { return 0 }
        return arr.count
    }
    
    /**
     Function to get row
     - parameter tableView: tableView reference
     - parameter indexPath: current indexPath of row
     - returns- cell object
     */

    func getCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as? FavoriteCell, let arr = arrFavorite else{
            return UITableViewCell()
        }
        let obj = arr[indexPath.row]
        cell.configureCell(objFav: obj)
        return cell
    }
    
    /**
     Function to manage table selection
     - parameter tableView: tableView reference
     - parameter indexPath: indexPath of selected row
     */
    func didSelectLevel(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let arr = arrFavorite else { return }
        delegate?.didSelectFavorite(objFav: arr[indexPath.row])
    }
}

