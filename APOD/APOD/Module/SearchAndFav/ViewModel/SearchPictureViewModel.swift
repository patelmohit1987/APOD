//
//  SearchPictureViewController.swift
//  APOD
//
//  Created by Patel, Mohit on 11/08/22.
//

import Foundation
import UIKit

/// enum to keep track of flow either Search screen or favorite detail screen
enum Flow {
    case search
    case favDetail
}
/// Protocol for communication between `SearchPictureViewModel` and associated controller
protocol SearchPictureViewModelDelegate: BaseViewModelDelegate {
    /**
     Show loading spinner
     */
    func showLoadingIndicator()
    
    /**
     Hide loading spinner
     */
    func hideLoadingIndicator()
    
    /**
     Method to notify API success
     */
    func didFetchPicOfDaySuccessfully(objAPOD: APODResponseModel)
}

/// View model class for Search Picture
class SearchPictureViewModel: BaseViewModel {
    // MARK: - Properties
    
    /// delegate object of SearchPictureViewModelDelegate
    weak var delegate: SearchPictureViewModelDelegate?
    
    /// date for which picture needs to be fetched
    var selectedDate: Date = Date()
    
    /// current selected APOD object reference
    var objAPOD: APODResponseModel?
    
    /// current selected fav object reference
    var objFav: Favorite?
    
    /// variable to keep track of flow either search or fav details
    var flow: Flow = .search
    
    /**
     Function to display alert in case of APOD API fails
     */
    private func failedToFetchPicture() {
        delegate?.showAlertMessage(title: StringLiterals.alertTitle_Fail, message: StringLiterals.alertMessage, actionTitles: [StringLiterals.alertButton_OK], style: [.default], actions: [nil])
    }
    
    /**
     Function to save object as favorite
     */
    func saveToFavorite() {
        guard let objAPOD = objAPOD else {
            return
        }
        if let date = objAPOD.date, !CoreDataOperationManager.isAlreadyMarkedFavorite(date: date) {
            CoreDataOperationManager.saveToFavorite(objAPOD: objAPOD)
        } else {
            print("Already added to favorite")
        }
        
    }
    
    /**
     Function to delete object from favorite
     */
    func deleteFromFavorite() {
            
        if flow == .search {
            if let objAPOD = objAPOD, let date = objAPOD.date {
                CoreDataOperationManager.deleteFromFavorite(date: date)
            }
        } else {
            if let objFav = objFav, let date = objFav.date {
                CoreDataOperationManager.deleteFromFavorite(date: date)
            }
        }
    }
    
    /**
     Function to check of the object is already added to fav
     */
    func isAlreadyAddedToFavorite() -> Bool {
        if flow == .search {
            if let objAPOD = objAPOD, let date = objAPOD.date {
                return CoreDataOperationManager.isAlreadyMarkedFavorite(date: date)
            }
            return false
        } else {
            if let objFav = objFav, let date = objFav.date {
                return CoreDataOperationManager.isAlreadyMarkedFavorite(date: date)
            }
            return false
        }
    }
}
/// MARK: - API calls
extension SearchPictureViewModel {
    /**
     Function to fetch Picture detail for given date
     */
    func getPictureDetail() {
        
        guard let strDate = selectedDate.string(format: DateFormat.API_DATE_FORMAT) else {
            return
        }
        delegate?.showLoadingIndicator()
        let queryParam = [APIJSONKeys.date: strDate, APIJSONKeys.api_key: EnvironmentProvider.apiKey, APIJSONKeys.thumbs: StringLiterals.thumb_true]
        
        APODRequest.getPickOfDay(queryParameters: queryParam).executeRequest { [weak self] resp in
            self?.delegate?.hideLoadingIndicator()
            guard let obj = resp as? APODResponseModel else { return }
            self?.objAPOD = obj
            self?.delegate?.didFetchPicOfDaySuccessfully(objAPOD: obj)
        } failureCallback: { [weak self] error in
            self?.delegate?.hideLoadingIndicator()
            self?.failedToFetchPicture()
        }
    }
}
