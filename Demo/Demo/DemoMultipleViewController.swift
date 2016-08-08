//
//  DemoMultipleViewController.swift
//  Demo
//
//  Created by Artem Krachulov.
//  Copyright © 2016 Artem Krachulov. All rights reserved.
//

import UIKit

class DemoMultipleViewController: DemoViewController {
  
  //  MARK: - Outlets
  
  @IBOutlet weak var activityWebView2: AKActivityWebView! {
    didSet {
      activityWebView2.activityIndicator.color = UIColor.blackColor()
    }
  }
  @IBOutlet weak var activityWebView3: AKActivityWebView! {
    didSet {
      activityWebView3.activityIndicator.color = UIColor.blackColor()
    }
  }
  
  //  MARK: - Life cycle
  
	override func viewDidLoad() {
		super.viewDidLoad()
		
		activityWebView2.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
		activityWebView3.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
	}
  
  //  MARK: - Helper
  
	override func switchText() {
		super.switchText()
		
		activityWebView2.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
		activityWebView3.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
	}
}