//
//  DemoViewController.swift
//  Demo
//
//  Created by Artem Krachulov.
//  Copyright © 2016 Artem Krachulov. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {
  
  //  MARK: - Outlets
  
  @IBOutlet weak var activityWebView: AKActivityWebView! {
    didSet {
      activityWebView.activityIndicator.color = UIColor.blackColor()
    }
  }  
	@IBOutlet weak var switchButton: UIBarButtonItem!
  
  //  MARK: - Properties

	final let html = [
		"<h2>Lorem Ipsum is simply dummy</h2><p>text of the printing and typesetting industry.</p><img src=\"http://lorempixel.com/300/150/sports/\"><p>Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p><p>It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</p><h1>It was popularised</h1><p>In the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>",
		"<p>Pellentesque rhoncus volutpat leo feugiat imperdiet. Vestibulum eu ultricies neque.</p>",
		"<p>Vivamus</p><img src=\"http://lorempixel.com/100/100/city/\">",
		"<img src=\"http://lorempixel.com/200/150/abstract/\"><p>Ut semper pharetra suscipit. Donec id aliquam eros. Suspendisse et laoreet lectus, ac imperdiet ex.</p><p>Donec pulvinar sapien nunc, sed blandit dui convallis quis. Nunc facilisis cursus nulla eget efficitur. Pellentesque eu est tellus. Pellentesque vitae porta augue. Sed tristique cursus risus. Fusce eget elit lacinia elit consequat placerat.</p><img src=\"http://lorempixel.com/400/300/animals/\">"
	]
  
  //  MARK: - Life cycle
  
	override func viewDidLoad() {
		super.viewDidLoad()
		
		switchText()
	}
	  
  //  MARK: - Actions
  
	@IBAction func switchAction(sender: AnyObject) {
		switchText()
	}
  
  //  MARK: - Helper
  
  func switchText() {
    activityWebView?.webView.loadHTMLString(html[random(html.count)], baseURL: nil)
  }
  
  final func random(max: Int) -> Int {
    return Int(arc4random_uniform(UInt32(max)))
  }
}