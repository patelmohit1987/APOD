//
//  FavoriteViewController.swift
//  APOD
//
//  Created by Patel, Mohit on 11/08/22.
//

import UIKit
/// View Controller Class for showing list of favorites
class FavoriteViewController: BaseViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tblFavorite: UITableView!
    @IBOutlet private weak var lblNoRecordFound: UILabel!
    
    /// View Model object
    let favoriteViewModel = FavoriteViewModel()
    
    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        favoriteViewModel.delegate = self
        self.title = "Favorite"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favoriteViewModel.fetchFavoritePictures()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    /**
     Function to show detail of selected fav row
     - parameter objFav: selected favorite object
     */
    func showDetailView(objFav: Favorite) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = sb.instantiateViewController(withIdentifier: "SearchPictureViewController") as? SearchPictureViewController else {
            print("SearchPictureViewController not found")
            return
        }
        vc.searchPictureViewModel.objFav = objFav
        vc.searchPictureViewModel.flow = .favDetail
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK:- Extension that implement table view delegate and data source methods
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteViewModel.getNumberOfRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return favoriteViewModel.getCell(tableView, cellForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        favoriteViewModel.didSelectLevel(tableView, didSelectRowAt: indexPath)
    }
}

// MARK:- Extension that implement FavoriteViewModelDelegate methods
extension FavoriteViewController: FavoriteViewModelDelegate {
    func toggleNoRecordLabel(isRecordFound: Bool) {
        if isRecordFound {
            tblFavorite.isHidden = false
            lblNoRecordFound.isHidden = true
        } else {
            tblFavorite.isHidden = true
            lblNoRecordFound.isHidden = false
        }
    }
    
    func didSelectFavorite(objFav: Favorite) {
        showDetailView(objFav: objFav)
    }
    
    func reloadTableView() {
        tblFavorite.reloadData()
    }
    
    
}
