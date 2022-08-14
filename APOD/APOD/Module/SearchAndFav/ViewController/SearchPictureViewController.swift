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
            self.updateUIWithFav()
        }
        
    }
    
    private func updateUIWith(objAPOD: APODResponseModel) {
        scrollView.isHidden = false
        
        var str: String? = objAPOD.hdurl
        if objAPOD.media_type == APIJSONKeys.video {
            str = objAPOD.thumbnail_url
            btnPlay.isHidden = false
        } else {
            btnPlay.isHidden = true
        }
        renderUIWith(date: objAPOD.date, title: objAPOD.title, explanation: objAPOD.explanation, mediaType: objAPOD.media_type, urlString: str)
        
    }
    
    func updateUIWithFav() {
        scrollView.isHidden = false
        btnSelectDate.isHidden = true
        
        guard let objFav = searchPictureViewModel.objFav else {
            return
        }
        var str: String? = objFav.hdurl
        if objFav.media_type == APIJSONKeys.video {
            str = objFav.thumbnail_url
            btnPlay.isHidden = false
        } else {
            btnPlay.isHidden = true
        }
        
        renderUIWith(date: objFav.date, title: objFav.title, explanation: objFav.explanation, mediaType: objFav.media_type, urlString: str)
        
    }
    
    func renderUIWith(date: String?, title: String?, explanation: String?, mediaType: String?, urlString: String?) {
        
        if let strURL = urlString, let url = URL(string: strURL) {
            activityIndicatorImageLoading.startAnimating()
            imgView.getImageFromServer(url: url) { isSuccess in
                DispatchQueue.main.async {
                    self.activityIndicatorImageLoading.stopAnimating()
                }
                
            }
        }
        lblDate.text = date
        lblTitle.text = title
        lblExplanation.text = explanation
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
    func didShowLastFetchedRecord(objLastSearch: LastSearch) {
        self.scrollView.isHidden = false
        
        var str: String? = objLastSearch.hdurl
        if objLastSearch.media_type == APIJSONKeys.video {
            str = objLastSearch.thumbnail_url
            self.btnPlay.isHidden = false
        } else {
            self.btnPlay.isHidden = true
        }
        self.renderUIWith(date: objLastSearch.date, title: objLastSearch.title, explanation: objLastSearch.explanation, mediaType: objLastSearch.media_type, urlString: str)
        
        
    }
    
    func showAlertMessage(title: String, message: String, actionTitles: [String], style: [UIAlertAction.Style], actions: [((UIAlertAction) -> Void)?]) {
        DispatchQueue.main.async {
            self.btnFavorite.isHidden = true
            self.showAlert(title: title, message: message, actionTitles: actionTitles, style: style, actions: actions)
        }
        
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
        btnSelectDate.isHidden = false
        btnFavorite.isHidden = false
        self.updateUIWith(objAPOD: objAPOD)
        
    }

}
