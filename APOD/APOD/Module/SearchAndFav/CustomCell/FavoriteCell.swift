//
//  FavoriteCell.swift
//  APOD
//
//  Created by Patel, Mohit on 14/08/22.
//

import UIKit
/// Custom cell for showing favorite data
class FavoriteCell: UITableViewCell {

    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var lblExplanation: UILabel!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var imgView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(objFav: Favorite) {
        self.tintColor = UIColor.white
        lblDate.text = objFav.date
        lblTitle.text = objFav.title
        lblExplanation.text = objFav.explanation
        var str: String? = objFav.url
        if objFav.media_type == "video" {
            str = objFav.thumbnail_url
        }
        if let strURL = str, let url = URL(string: strURL) {
            activityIndicator.startAnimating()
            imgView.getImageFromServer(url: url) { isSuccess in
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                
            }
        }
    }

}
