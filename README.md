# AKActivityWebView

**`AKActivityWebView`** is `UIView` class with activity indicator and web view. Supporting auto resizing dimensions according content size after web view finish loading.

## Features

* Animation support
* Manually control resizing dimensions
* Lightweight

## Usage


### Standalone

```swift
@IBOutlet weak var activityWebView: AKActivityWebView!

override func viewDidLoad() {
    super.viewDidLoad()

    activityWebView.webView.loadHTMLString("<h2>Lorem Ipsum is simply dummy text</h2>", baseURL: nil)
}
```

---

## Requirements

- iOS 8.0+
- Xcode 7.3+

## Installation

1. Clone or download demo project.
2. Add `AKActivityWebView` folder to your project.

## Acces to objects

```swift
public var webView: UIWebView!
```
`UIWebView` class. Read more [UIWebView Class Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIWebView_Class/)

You can customize `backgroundColor` and `opaque` properties from `AKActivityWebView` object. Customization of this properties will take effect on `webView` object. 


```swift
public var activityIndicator: UIActivityIndicatorView!
```
`UIActivityIndicatorView` class. Read more [UIActivityIndicatorView Class Reference](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIActivityIndicatorView_Class/)

## Auto resizing dimensions

```swift
public var adjustingDimensions: AKActivityWebViewAdjustingDimensions
```
Adjusting `AKActivityWebView` height (and height constraint) after loading content.   
The initial value of this property is `.Auto`

Options:

- `.Auto` : Depends on vertical constraint. If height constraint will exist, frames will take size of loaded content size. Otherwise frames sizes will not changed and web view will have scroll if needed.
- `.Disable` : Frames sizes will not changed and web view will have scroll if needed.
- `.Enable` : Frames will take size of loaded content size.

## Animation

```swift
public var animationEnabled: Bool
```
A Boolean value that determines whether animation is enabled.   
The initial value of this property is `false`.


```swift
public var animationOptions: AKActivityWebViewAnimationOptions
```
Animation options.

Parameters:

- `duration` : The total duration of the animations, measured in seconds. If you specify a negative value or 0, the changes are made without animating them.
- `option` : A mask of options indicating how you want to perform the animations. For a list of valid constants, see UIViewAnimationOptions.


## Set up

```swift
public var activityIndicatorEnabled: Bool
```
Show or hide activity indicator generally.   
The initial value of this property is `true`.

```swift
public var hideWebViewOnLoading: Bool
```

Hide and show web view if loading process is active.   
The initial value of this property is `true`.

### Accessing the Delegate

```swift
weak var delegate: AKActivityWebViewDelegate?
```

The delegate object to receive update events.

## AKActivityWebViewDelegate

```swift
optional func activityWebViewDidStartLoad(activityWebView: AKActivityWebView, webView: UIWebView)
```
Sent after a web view starts loading a frame.

Parameters:

- `activityWebView` : The main object.
- `webView` : The web view that has begun loading a new frame.

```swift
optional func activityWebViewFinishLoad(activityWebView: AKActivityWebView, webView: UIWebView)
```
Sent after a web view finishes loading a frame.

Parameters:

- `activityWebView` : The main object.
- `webView` : The web view has finished loading.

```swift
optional func activityWebView(activityWebView: AKActivityWebView, webView: UIWebView, didFailLoadWithError error: NSError?)
```
Sent if a web view failed to load a frame.

Parameters:

- `activityWebView` : The main object.
- `webView` : The web view that failed to load a frame.
- `error` : The error that occurred during loading.

---

Please do not forget to ★ this repository to increases its visibility and encourages others to contribute.

### Author

Artem Krachulov: [www.artemkrachulov.com](http://www.artemkrachulov.com/)
Mail: [artem.krachulov@gmail.com](mailto:artem.krachulov@gmail.com)

### License

Released under the [MIT license](http://www.opensource.org/licenses/MIT)