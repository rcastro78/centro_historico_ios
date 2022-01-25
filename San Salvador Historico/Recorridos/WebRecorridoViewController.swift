//
//  WebRecorridoViewController.swift
//  San Salvador Historico
//
//  Created by Rafael David Castro Luna on 3/12/21.
//  Copyright © 2021 The Kitchen DS. All rights reserved.
//

import UIKit
import WebKit
class WebRecorridoViewController: UIViewController,WKNavigationDelegate {

    @IBOutlet weak var webRecorrido360: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let videoUrl = UserDefaults.standard.string(forKey:"videoUrl")!
        let link = URL(string:videoUrl)!
        let request = URLRequest(url: link)
        webRecorrido360.scrollView.showsHorizontalScrollIndicator = false
        webRecorrido360.scrollView.pinchGestureRecognizer?.isEnabled = false
        webRecorrido360.configuration.preferences.javaScriptEnabled = true
        webRecorrido360.navigationDelegate = self
        webRecorrido360.contentMode = .scaleAspectFit
        webRecorrido360.load(request)
        webRecorrido360.scrollView.isScrollEnabled = true
        webRecorrido360.scrollView.bounces = false
        webRecorrido360.allowsBackForwardNavigationGestures = false
        
        // Do any additional setup after loading the view.
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
