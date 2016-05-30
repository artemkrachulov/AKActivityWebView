//
//  ThirdViewController.swift
//  AKActivityWebView
//
//  Created by Artem Krachulov.
//  Copyright © 2016 Artem Krachulov. All rights reserved.
//

import UIKit

class ThirdViewController: ViewController {	
  
  //  MARK: - Outlets
  
	@IBOutlet weak var webView2: AKActivityWebView!
	@IBOutlet weak var webView3: AKActivityWebView!
  
  //  MARK: - Life cycle
  
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView2.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
		webView3.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
	}
  
  //  MARK: - Helper
  
	override func switchText() {
		super.switchText()
		
		webView2.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
		webView3.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
	}
}