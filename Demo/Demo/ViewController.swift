//
//  ViewController.swift
//  UIActivityWebView / Demo
//
//  Created by Krachulov Artem
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	// MARK: - Outlets
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	@IBOutlet weak var webView1: UIActivityWebView!
	
	@IBOutlet weak var switchButton: UIBarButtonItem!
	
	// Props
	
	var switched = false
	
	// MARK: - Life cycle
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		switchText()
	}
	
	// MARK: - Helper
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	func switchText() {
		
		let text1 = switched ? "<p>Morbi nec sem eget turpis malesuada rhoncus nec in tortor. Vivamus sed sem turpis. Aenean aliquet posuere laoreet.</p>" : "<h3>Lorem Ipsum</h3><p><b>Lorem Ipsum</b> is simply dummy text of the printing and typesetting industry.</p><p>Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.</p><img src=\"http://lorempixel.com/400/200/sports/\"><p>It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged.</p><img src=\"http://lorempixel.com/400/200/abstract/\"><p>It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</p>"
		
		if webView1 != nil {
			webView1.webView.loadHTMLString(text1, baseURL: nil)
		}
	}
	
	// MARK: - Actions
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	@IBAction func switchAction(sender: AnyObject) {
		switched = !switched
		switchText()
	}
}