//
//  ThirdViewController.swift
//  UIActivityWebView / Demo
//
//  Created by Krachulov Artem
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

class ThirdViewController: ViewController {	

	// MARK: - Outlets
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	@IBOutlet weak var webView2: UIActivityWebView!
	
	@IBOutlet weak var webView3: UIActivityWebView!
	
	// MARK: - Life cycle
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView2.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
		webView3.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
	}
	
	// MARK: - Helper
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	override func switchText() {
		super.switchText()
		
		webView2.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
		webView3.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
	}
}