//
//  UIActivityWebView.swift
//  UIActivityWebView
//
//  Created by Krachulov Artem 
//

import UIKit

struct UIActivityWebViewAnimationOptions {
	var duration: NSTimeInterval!
	var option: UIViewAnimationOptions!
}

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

class UIActivityWebView: UIView, UIWebViewDelegate, UIScrollViewDelegate {
	
	// MARK: - Outlets
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
		didSet {
			activityIndicator.hidden = !showActivityOnLoad
		}
	}
	
	@IBOutlet weak var webView: UIWebView! {
		didSet {
			webView.delegate = self
			webView.hidden = true
			
			webView.scrollView.delegate = self
		}
	}	
	
	var heightConstraint: NSLayoutConstraint!
	
	// MARK: - Properties
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	var delagate: UIActivityWebViewDelegate?
	
	// Settings
	
	var animation: Bool = false
	var animationOptions: UIActivityWebViewAnimationOptions?
	
	var showActivityOnLoad: Bool = true
	var hideOnStartLoading: Bool = true
	
	// Flags
	
	var flag_loaded: Bool = false
	
	// MARK: - Initialization
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	init() {
		super.init(frame: CGRectZero)
		
		loadFromNib(nil, bundle: nil)
		reset()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		loadFromNib(nil, bundle: nil)
		reset()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		loadFromNib(nil, bundle: nil)
		reset()
	}
	
	func reset() {
		webView.hidden = true
		webView.alpha = 0.0
		
		activityIndicator.hidden = false
		activityIndicator.alpha = 1.0
	}
	
	// MARK: - UIWebViewDelegate
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		
		return delagate?.webView?(self, shouldStartLoadWithRequest: request, navigationType: navigationType) ?? true
	}

	func webViewDidStartLoad(webView: UIWebView) {
		
		flag_loaded = false
		
		if webView.hidden {
			
			activityIndicator.hidden = !showActivityOnLoad
			activityIndicator.alpha = 1.0

		} else {

			if hideOnStartLoading {
			
				webView.alpha = 0
				
				activityIndicator.hidden = !showActivityOnLoad
				activityIndicator.alpha = 1
			
			} else {
				
				webView.alpha = 1
				
				activityIndicator.hidden = true
				activityIndicator.alpha = 0
			}
		}
		
		webView.hidden = false

		delagate?.webViewDidStartLoad?(self)
	}
	

	var height: NSLayoutConstraint! {
		for constraint in self.constraints {
			if constraint.secondItem == nil && constraint.firstAttribute == NSLayoutAttribute.Height {
				return constraint
			}
		}
		return nil
	}
	
	func webViewDidFinishLoad(webView: UIWebView) {
		
		flag_loaded = true
		
		if animation {
			
			UIView.animateWithDuration(animationOptions?.duration ?? 0.3, delay: 0.0, options: animationOptions?.option ?? UIViewAnimationOptions.TransitionNone,
				animations: {
					
					self.activityIndicator.alpha = 0.0
					webView.alpha = 1.0
					
				}, completion: nil)

		} else {
			
			webView.alpha = 1.0
			
			activityIndicator.hidden = true
			activityIndicator.alpha = 0.0
		}
		
		layoutSubviews()
		
		delagate?.webViewDidFinishLoad?(self)
	}

	func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
		
		flag_loaded = false
		
		layoutSubviews()
		
		delagate?.webView?(self, didFailLoadWithError: error)
	}	
	
	// MARK: - UIScrollViewDelegate
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	func scrollViewDidScroll(scrollView: UIScrollView) {
		if height != nil {
			scrollView.contentOffset.y = 0
		}
	}
	
	// MARK: - Layout
	//         _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
	
	
	override func layoutSubviews() {

		let originalSize = webView.frame.size
		
		webView.frame.size.height = 1
		var contentSize = webView.scrollView.contentSize

		// Sometimes contentSize receive not correct size values
		// so I get contentSize from web view document
		
		if flag_loaded {
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
		
		if height != nil {
			
			height.constant = contentSize.height
			
			frame.size.height = contentSize.height
			webView.frame.size.height = contentSize.height
			webView.scrollView.frame.size.height = contentSize.height
			
		} else {
			webView.frame.size = webView.scrollView.scrollEnabled ? originalSize : webView.scrollView.contentSize
			webView.scrollView.frame.size = webView.frame.size
		}
		
		#if AKUIActivityWebViewDEBUG
			print("Object ::::::: UIActivityWebView")
			print("Method ::::::: layoutSubviews")
			print("               - -")
			print("Properties ::: contentSize = \(contentSize)")
			print("                  ")			
			print("               UIActivityWebView = \(self.frame)")
			print("               ↳ webView = \(webView.frame)")
			print("                 ↳ scrollView = \(webView.scrollView.frame)")
			print("                   - contentSize = \(webView.scrollView.contentSize)")
			print("")
		#endif
	}
}