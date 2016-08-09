//
//  AKActivityWebView.swift
//  UIWebView + UIActivityIndicatorView in one view.
//
//  Created by Artem Krachulov
//  Copyright (c) 2016 Artem Krachulov. All rights reserved.
//	http://www.artemkrachulov.com
//

import UIKit

public struct AKActivityWebViewAnimationOptions {
  
  /// The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
  public var duration: NSTimeInterval
  
  /// A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.
  public var option: UIViewAnimationOptions
}

public enum AKActivityWebViewAdjustingDimensions {
  
  /// Depends on vertical constraint. If height constraint will exist, frames will take size of loaded content size. Otherwise frames sizes will not changed and web view will have scroll if needed.
  case Auto
  
  /// Frames sizes will not changed and web view will have scroll if needed.
  case Disable
  
  /// Frames will take size of loaded content size.
  case Enable
}

//  MARK: - Protocol: AKActivityWebViewDelegate

@objc protocol AKActivityWebViewDelegate {
  
  /// Sent after a web view starts loading a frame.
  ///
  /// - parameter activityWebView: The main object.
  /// - parameter webView: The web view that has begun loading a new frame.
  optional func activityWebViewDidStartLoad(activityWebView: AKActivityWebView, webView: UIWebView)
  
  /// Sent after a web view finishes loading a frame.
  ///
  /// - parameter activityWebView: The main object.
  /// - parameter webView: The web view has finished loading.
	optional func activityWebViewFinishLoad(activityWebView: AKActivityWebView, webView: UIWebView)
  
  /// Sent if a web view failed to load a frame.
  ///
  /// - parameter activityWebView: The main object.
  /// - parameter webView: The web view that failed to load a frame.
  /// - parameter error: The error that occurred during loading.
	optional func activityWebView(activityWebView: AKActivityWebView, webView: UIWebView, didFailLoadWithError error: NSError?)
}

/// Class with activity indicator and web view. Supporting auto resizing dimensions according content size after web view finish loading.
///
/// Example of usage:
///
/// ```
/// activityWebView.webView.loadHTMLString("<h2>Lorem Ipsum is simply dummy text</h2>", baseURL: nil)
/// ```
///
/// For more information click here [GitHub](https://github.com/artemkrachulov/AKActivityWebView)

public class AKActivityWebView: UIView {
  
  //  MARK: - Properties
  //  MARK: Hierarchy
  
  /// Height constraint which set from storyboard or manually, before initialization.
  private var heightConstraint: NSLayoutConstraint?
  
  /// Activity indicator. 
  /// Read more [UIActivityIndicatorView Class Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIActivityIndicatorView_Class/)
  public var activityIndicator: UIActivityIndicatorView!
  
  /// Web view for representing content.
  /// Read more [UIWebView Class Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIWebView_Class/)
  public var webView: UIWebView!
  
  // Overrides stored properties and translate to webView
  
  public override var backgroundColor: UIColor?  {
    didSet(newValue) {
      webView?.backgroundColor = newValue
    }
  }
  
  public override var opaque: Bool {
    didSet(newValue) {
      webView?.opaque = newValue
    }
  }
  
  //  MARK: Auto resizing dimensions
  
  /// Adjusting `AKActivityWebView` height (and height constraint) after loading content.
  /// The initial value of this property is `.Auto`
  public var adjustingDimensions : AKActivityWebViewAdjustingDimensions = .Auto
  
  //  MARK: Animation
  
  /// A Boolean value that determines whether animation is enabled.
  /// The initial value of this property is `false`.
  public var animationEnabled = true
  
  /// Animation options.
  ///
  /// - parameter duration: The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
  /// - parameter options: A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.
  public var animationOptions = AKActivityWebViewAnimationOptions(duration: 0.3, option: .CurveEaseInOut)

  //  MARK: Set up

  /// Show or hide activity indicator generally.
  /// The initial value of this property is `true`.
	public var activityIndicatorEnabled: Bool = true
  
  /// Hide and show web view if loading process is active.
  /// The initial value of this property is `true`.
	public var hideWebViewOnLoading: Bool = true

  /// A Boolean value that determines whether loading is finished.
  private var loadingFinished: Bool = false
  
  //  MARK: Properties
  
  /// The delegate object to receive update events.
  weak var delegate: AKActivityWebViewDelegate?
  
    //  MARK: - Initialization
  
	init() {
		super.init(frame: CGRectZero)
		setupUI()
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupUI()
	}
  
  deinit {
    #if AKActivityWebViewDEBUG
      print("\(self.dynamicType) \(#function)")
    #endif
  }
	
  private func setupUI() {

    heightConstraint = heightContraint(self)
    
    webView = UIWebView()
    webView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(webView)
    
    if #available(iOS 9.0, *) {
      webView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
      webView.rightAnchor.constraintEqualToAnchor(rightAnchor).active = true
      webView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
      webView.leftAnchor.constraintEqualToAnchor(leftAnchor).active = true
    } else {
      let viewsDictionary = ["webView": webView]
      addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-0-[webView]-0-|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views:
        viewsDictionary))
      
      addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-0-[webView]-0-|",
        options: NSLayoutFormatOptions(rawValue: 0),
        metrics: nil,
        views: viewsDictionary))
    }
    
    
    activityIndicator = UIActivityIndicatorView()
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    addSubview(activityIndicator)
    
    if #available(iOS 9.0, *) {
      activityIndicator.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
      activityIndicator.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
    } else {
      addConstraint(NSLayoutConstraint(
        item: activityIndicator,
        attribute: .CenterX,
        relatedBy: .Equal,
        toItem: self,
        attribute: .CenterX,
        multiplier: 1,
        constant: 0
        ))
      
      addConstraint(NSLayoutConstraint(
        item: activityIndicator,
        attribute: .CenterY,
        relatedBy: .Equal,
        toItem: self,
        attribute: .CenterY,
        multiplier: 1,
        constant: 0
        ))
    }
    
    webView.delegate = self
    webView.backgroundColor = backgroundColor
    webView.opaque = opaque
  }
 
  //  MARK: - Layouting
  
	override public func layoutSubviews() {

    if loadingFinished {
      
      webView.frame.size.height = 1
      
      var contentSize = webView.scrollView.contentSize
      
      // Sometimes contentSize receive not correct size values
      // so I get contentSize from web view document
      
      if let jSHeight = webView.stringByEvaluatingJavaScriptFromString("document.height") {
        if let jDHeight = Double(jSHeight), height = CGFloat(jDHeight) as CGFloat? {
          contentSize.height = height != contentSize.height ? height : contentSize.height
        }
      }
      if let jSWidth = webView.stringByEvaluatingJavaScriptFromString("document.width") {
        if let jDWidth = Double(jSWidth), width = CGFloat(jDWidth) as CGFloat? {
          contentSize.width = width != contentSize.width ? width : contentSize.width
        }
      }
      
      if adjustingDimensions == .Auto {
        if heightConstraint != nil {
          heightConstraint?.constant = contentSize.height
          webView.frame.size = contentSize
        } else {
          heightConstraint?.constant = frame.size.height
          webView.frame.size = frame.size
        }
      } else if adjustingDimensions == .Enable {
        heightConstraint?.constant = contentSize.height
        webView.frame.size = contentSize
      } else {
        heightConstraint?.constant = frame.size.height
        webView.frame.size = frame.size
      }
    } else {
      heightConstraint?.constant = frame.size.height
    }
 
    super.layoutSubviews()
    
    #if AKActivityWebViewDEBUG
      print("\(self.dynamicType) \(#function)")
      print("AKActivityWebView: \(self)")
      print("webView: \(webView)")
    #endif
	}
  
  private func heightContraint(view: UIView) -> NSLayoutConstraint! {
    for constraint in view.constraints {
      if constraint.firstAttribute == NSLayoutAttribute.Height && constraint.secondItem == nil {
        return constraint
      }
    }
    return nil
  }
  
  private func _webViewDidFinishLoad(webView: UIWebView) {

    loadingFinished = true
    
    activityIndicator.stopAnimating()

    if animationEnabled {
      UIView.animateWithDuration(animationOptions.duration,
                                 delay: 0.0,
                                 options: animationOptions.option,
                                 animations: {
                                  self.activityIndicator.alpha = 0.0
                                  webView.alpha = 1.0
                                  
        }, completion: { done in
          if done && self.activityIndicator.alpha == 0.0 {
            self.activityIndicator.hidden = true
          }
      })
    } else {      
      activityIndicator.alpha = 0.0
      webView.alpha = 1.0
      
      activityIndicator.hidden = true
    }
    
    layoutSubviews()
  }
}

//  MARK: - UIWebViewDelegate

extension AKActivityWebView: UIWebViewDelegate {

  public func webViewDidStartLoad(webView: UIWebView) {

    loadingFinished = false
    
    activityIndicator.startAnimating()

    if hideWebViewOnLoading {
      webView.alpha = 0
      activityIndicator.hidden = !activityIndicatorEnabled
      activityIndicator.alpha = 1
    } else {
      webView.alpha = 1
      activityIndicator.hidden = true
      activityIndicator.alpha = 0
    }

    delegate?.activityWebViewDidStartLoad?(self, webView: webView)
  }
  
  public func webViewDidFinishLoad(webView: UIWebView) {
    _webViewDidFinishLoad(webView)
    delegate?.activityWebViewFinishLoad?(self, webView: webView)
  }
  
  public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
    _webViewDidFinishLoad(webView)
    delegate?.activityWebView?(self, webView: webView, didFailLoadWithError: error)
  }
}