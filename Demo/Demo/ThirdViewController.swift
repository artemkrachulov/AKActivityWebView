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
	
	// MARK: - Helper
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	override func switchText() {
		super.switchText()
		
		let text2 = switched ? "<img src=\"http://lorempixel.com/500/400/technics/\">" : "<p>In euismod pellentesque tincidunt. Quisque commodo magna a posuere dictum.</p><img src=\"http://lorempixel.com/400/200/sports/\"><p>Mauris nisi lectus, aliquam vitae pulvinar vel, tincidunt quis velit. Etiam in libero faucibus, tempor ligula eget, sollicitudin diam.</p><img src=\"http://lorempixel.com/400/200/abstract/\"><p>It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum</p>"
		
		let text3 = switched ? "<b>Duis placerat leo ipsum, eget molestie odio hendrerit sit amet.</b><img src=\"http://lorempixel.com/300/300/animals/\"><p>Phasellus in suscipit purus. Cras tempor dolor vel elit ultrices vestibulum. Aenean eu ultricies dui, non pretium nisl.</p>" : "<p>Morbi nec sem eget turpis malesuada rhoncus nec in tortor. Vivamus sed sem turpis. Aenean aliquet posuere laoreet.</p>"
		
		webView2.webView.loadHTMLString(text2, baseURL: nil)
		webView3.webView.loadHTMLString(text3, baseURL: nil)
	}
}