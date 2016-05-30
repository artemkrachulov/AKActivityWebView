//
//  AKActivityWebView.swift
//  UIWebView + UIActivityIndicatorView in one view.
//
//  Created by Artem Krachulov
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//	http://www.artemkrachulov.com
//

import UIKit

struct AKActivityWebViewAnimationOptions {
	var duration: NSTimeInterval!
	var option: UIViewAnimationOptions!
}

//  MARK: - Protocol

@objc protocol AKActivityWebViewDelegate: NSObjectProtocol {
	optional func webView(webView: AKActivityWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool
	optional func webViewDidStartLoad(webView: AKActivityWebView)
	optional func webViewDidFinishLoad(webView: AKActivityWebView)
	optional func webView(webView: AKActivityWebView, didFailLoadWithError error: NSError?)
}

/// Class AKActivityWebView contain UIWebView and UIActivityIndicatorView. 
/// When UIWebView loads new content AKActivityWebView show loader. 
///
class AKActivityWebView: UIView {
  
  //  MARK: - Outlets
  
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
  
  //  MARK: - Properties
  
	weak var delagate: AKActivityWebViewDelegate?
  
  //  MARK:   Settings
  
	var animation: Bool = false
	var animationOptions: AKActivityWebViewAnimationOptions?
	
	var showActivityOnLoad: Bool = true
	var hideOnStartLoading: Bool = true
	
  //  MARK:   Flags
  
	private var isLoading: Bool = false
  
  //  MARK:   Other
  
  var height: NSLayoutConstraint! {
    for constraint in self.constraints {
      if constraint.secondItem == nil && constraint.firstAttribute == NSLayoutAttribute.Height {
        return constraint
      }
    }
    return nil
  }
  
  //  MARK: - Initialization
  
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
  
  //  MARK: - Layout
  
	override func layoutSubviews() {

		let originalSize = webView.frame.size
		
		webView.frame.size.height = 1
		var contentSize = webView.scrollView.contentSize

		//  Sometimes contentSize receive not correct size values
		//  so I get contentSize from web view document
		
		if isLoading {
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
	}
}

//  MARK: - UIWebViewDelegate

extension AKActivityWebView: UIWebViewDelegate {
  
  func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    return delagate?.webView?(self, shouldStartLoadWithRequest: request, navigationType: navigationType) ?? true
  }
  
  func webViewDidStartLoad(webView: UIWebView) {
    isLoading = false
    
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
  
  func webViewDidFinishLoad(webView: UIWebView) {
    isLoading = true
    
    if animation {
      UIView.animateWithDuration(animationOptions?.duration ?? 0.3,
                                 delay: 0.0,
                                 options: animationOptions?.option ?? UIViewAnimationOptions.TransitionNone,
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
    isLoading = false
    
    layoutSubviews()
    delagate?.webView?(self, didFailLoadWithError: error)
  }
  
}

//  MARK: - UIScrollViewDelegate

extension AKActivityWebView: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if height != nil {
      scrollView.contentOffset.y = 0
    }
  }
}