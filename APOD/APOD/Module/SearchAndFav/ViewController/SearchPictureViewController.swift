//
//  SearchPictureViewController.swift
//  APOD
//
//  Created by Patel, Mohit on 11/08/22.
//

import UIKit
import SafariServices
/// View Controller Class for searching pic for selected date
class SearchPictureViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var btnSelectDate: UIButton!
    @IBOutlet private weak var btnPlay: UIButton!
    @IBOutlet private weak var btnFavorite: UIButton!
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var viewPicker: UIView!
    @IBOutlet private weak var constraintPickerHeight: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblExplanation: UILabel!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var activityIndicatorImageLoading: UIActivityIndicatorView!
    
    /// View Model object
    let searchPictureViewModel = SearchPictureViewModel()
    
    // MARK: Properties
    let pickerHeight = 260.0
    
    
    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if searchPictureViewModel.isAlreadyAddedToFavorite() {
            btnFavorite.isSelected = true
        } else {
            btnFavorite.isSelected = false
        }
    }
    
    // MARK: - User defined private methods
    private func configureView() {
        searchPictureViewModel.delegate = self
        datePicker.maximumDate = Date()
        scrollView.isHidden = true
        self.constraintPickerHeight.constant =  0
        if searchPictureViewModel.flow == .search {
            searchPictureViewModel.getPictureDetail()
        } else {
            updateUIWithFav()
        }
        
    }
    
    private func updateUIWith(objAPOD: APODResponseModel) {
        scrollView.isHidden = false
        lblDate.text = objAPOD.date
        lblTitle.text = objAPOD.title
        lblExplanation.text = objAPOD.explanation
        var str: String? = objAPOD.hdurl
        if objAPOD.media_type == APIJSONKeys.video {
            str = objAPOD.thumbnail_url
            btnPlay.isHidden = false
        } else {
            btnPlay.isHidden = true
        }
        if let strURL = str, let url = URL(string: strURL) {
            activityIndicatorImageLoading.startAnimating()
            imgView.getImageFromServer(url: url) { isSuccess in
                self.activityIndicatorImageLoading.stopAnimating()
            }
        }
        if searchPictureViewModel.isAlreadyAddedToFavorite() {
            btnFavorite.isSelected = true
        } else {
            btnFavorite.isSelected = false
        }
        
    }
    
    func updateUIWithFav() {
        scrollView.isHidden = false
        btnSelectDate.isHidden = true
        
        guard let objFav = searchPictureViewModel.objFav else {
            return
        }
        
        lblDate.text = objFav.date
        lblTitle.text = objFav.title
        lblExplanation.text = objFav.explanation
        var str: String? = objFav.hdurl
        if objFav.media_type == "video" {
            str = objFav.thumbnail_url
            btnPlay.isHidden = false
        } else {
            btnPlay.isHidden = true
        }
        if let strURL = str, let url = URL(string: strURL) {
            activityIndicatorImageLoading.startAnimating()
            imgView.getImageFromServer(url: url) { isSuccess in
                self.activityIndicatorImageLoading.stopAnimating()
            }
        }
        if searchPictureViewModel.isAlreadyAddedToFavorite() {
            btnFavorite.isSelected = true
        } else {
            btnFavorite.isSelected = false
        }
    }
    
    // MARK: - Actions
    
    @IBAction func btnDoneAction(_ sender: Any) {
        searchPictureViewModel.selectedDate = datePicker.date
        UIView.animate(withDuration: 0.5) {
            self.constraintPickerHeight.constant =  0
            self.view.layoutIfNeeded()
        } completion: { isComplete in
            if isComplete {
                self.searchPictureViewModel.getPictureDetail()
            }
        }
    }
    
    @IBAction func btnSelectDateAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.constraintPickerHeight.constant =  self.pickerHeight
            self.view.layoutIfNeeded()
        })

    }
    
    @IBAction func btnFavoriteAction(_ sender: Any) {
        
        if btnFavorite.isSelected {
            searchPictureViewModel.deleteFromFavorite()
            self.navigationController?.popViewController(animated: true)
        } else {
            searchPictureViewModel.saveToFavorite()
        }
        btnFavorite.isSelected = !btnFavorite.isSelected
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showVideo", let vc = segue.destination as? PlayVideoViewController {
            if searchPictureViewModel.flow == .search {
                if let url = searchPictureViewModel.objAPOD?.url {
                    vc.strURL = url
                }
            } else {
                if let url = searchPictureViewModel.objFav?.url {
                    vc.strURL = url
                }
            }
            
        }
    }
    

}
// MARK: - Extension to conform to SearchPictureViewModelDelegate methods
extension SearchPictureViewController: SearchPictureViewModelDelegate {
    func showAlertMessage(title: String, message: String, actionTitles: [String], style: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]) {
        showAlert(title: title, message: message, actionTitles: actionTitles, style: style, actions: actions)
    }
    
    func showLoadingIndicator() {
        btnSelectDate.isEnabled = false
        scrollView.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        btnSelectDate.isEnabled = true
        scrollView.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
    
    func didFetchPicOfDaySuccessfully(objAPOD: APODResponseModel) {
        self.updateUIWith(objAPOD: objAPOD)
    }

}
