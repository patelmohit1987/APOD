//
//  PlayVideoViewController.swift
//  APOD
//
//  Created by Patel, Mohit on 13/08/22.
//

import UIKit
import WebKit
/// View Controller Class for showing video in webview
class PlayVideoViewController: UIViewController {

    @IBOutlet private weak var webView: WKWebView!
    var strURL: String?
    
    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let strURL = strURL, let url = URL(string: strURL) {
            webView.load(URLRequest(url: url))
        }
    }
    
    // MARK: - Action Methods
    @IBAction func btnClosePlayerAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
