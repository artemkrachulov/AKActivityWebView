//
//  UIActivityWebView.swift
//  UIActivityWebView
//
//  Created by Krachulov Artem 
//  Copyright © 2016 Krachulov Artem . All rights reserved.
//

import UIKit

// MARK: - Protocol
//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

@objc protocol UIActivityWebViewDelegate: NSObjectProtocol {
	
	optional func webView(webView: UIActivityWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
	
	optional func webViewDidStartLoad(webView: UIActivityWebView)
	
	optional func webViewDidFinishLoad(webView: UIActivityWebView)
	
	optional func webView(webView: UIActivityWebView, didFailLoadWithError error: NSError?)
}

// MARK: - Class
//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _

class UIActivityWebView: UIView, UIWebViewDelegate {
	
	// MARK: - Outlets
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	@IBOutlet weak var webView: UIWebView! {
		didSet {
			webView.delegate = self
			
			webView.hidden = true
			webView.alpha = 0.0
		}
	}	
	
	// MARK: - Properties
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	var delagate: UIActivityWebViewDelegate?
	
	// Settings
	
	var animated: Bool = false
	
	// Flags
	
	var loaded: Bool = false

	var heightConstraint: NSLayoutConstraint!
	
	init() {
		super.init(frame: CGRectZero)
		
		loadFromNib(nil, bundle: nil)
		setup()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		loadFromNib(nil, bundle: nil)
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		loadFromNib(nil, bundle: nil)
		setup()
	}
	
	func setup() {
	
		if let _heightConstraint = constraints.first as NSLayoutConstraint! {
			
			heightConstraint = _heightConstraint
			
			webView.scrollView.scrollEnabled = false
		}
	}
	
	// MARK: - UIWebViewDelegate
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		
		return delagate?.webView?(self, shouldStartLoadWithRequest: request, navigationType: navigationType) ?? true
	}

	func webViewDidStartLoad(webView: UIWebView) {
		
		loaded = false
		
		if !webView.hidden {
		
			activityIndicator.hidden = false
			activityIndicator.alpha = 0.0
			
			webView.hidden = false
			webView.alpha = 1.0
			
			if animated {
				UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve,
					animations: {
						
						self.activityIndicator.alpha = 1.0
						webView.alpha = 0.0
					
					}, completion: { (Bool) -> Void in
						
						self.activityIndicator.hidden = false
					}
				)
				
			} else {
				
				activityIndicator.hidden = false
				activityIndicator.alpha = 1.0
				
				webView.alpha = 0.0
			}
		}
		
		delagate?.webViewDidStartLoad?(self)
	}

	func webViewDidFinishLoad(webView: UIWebView) {

		loaded = true
		
		layoutSubviews()
		
		activityIndicator.hidden = false
		activityIndicator.alpha = 1.0
		
		webView.hidden = false
		webView.alpha = 0.0
		
		if animated {
			
			UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve,
				animations: {
				
					self.activityIndicator.alpha = 0.0
					webView.alpha = 1.0
				
				}, completion: { (Bool) -> Void in
					
					self.activityIndicator.hidden = true
			})
		
		} else {
			
			activityIndicator.hidden = true
			activityIndicator.alpha = 0.0
			
			webView.alpha = 1.0
		}
		
		delagate?.webViewDidFinishLoad?(self)
	}

	func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
		
		loaded = false
		
		delagate?.webView?(self, didFailLoadWithError: error)
	}
	
	// MARK: - Layout
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	override func layoutSubviews() {
		super.layoutSubviews()

		let originalSize = webView.frame.size
		
		webView.frame.size.height = 1
		var contentSize = webView.scrollView.contentSize

		// Sometimes contentSize receive not correct size values
		// so I get contentSize from web view document
		
		if loaded {
			if let jHeight = webView.stringByEvaluatingJavaScriptFromString("document.height") {
				if let jDHeight = Double(jHeight) {

					contentSize.height = CGFloat(jDHeight) != contentSize.height ? CGFloat(jDHeight) : contentSize.height
				}
			}
			if let jWidth = webView.stringByEvaluatingJavaScriptFromString("document.width") {
				if let jDWidth = Double(jWidth) {
					
					contentSize.width = CGFloat(jDWidth) != contentSize.width ? CGFloat(jDWidth) : contentSize.width
				}
			}
		}
		
		if heightConstraint != nil {
			
			heightConstraint.constant = contentSize.height
			webView.frame.size.height = contentSize.height
			
		} else {
			webView.frame.size = webView.scrollView.scrollEnabled ? originalSize : webView.scrollView.contentSize
		}
		
		#if AKDEBUG
			print("Object ::::::: UIActivityWebView")
			print("Method ::::::: layoutSubviews")
			print("               - -")
			print("Properties ::: webView contentSize > > > \(webView.scrollView.contentSize)")
			print(":::::::::::::: contentSize > > > \(contentSize)")
			print("")
		#endif
	}
}