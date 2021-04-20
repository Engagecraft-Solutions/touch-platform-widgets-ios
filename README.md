# Touch

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Touch is available through private cocoapods git repo. To install
it, get access to this git repo and simply add the following line to your Podfile:

```ruby
pod 'Touch', :git => 'git@github.com:Engagecraft-Solutions/touch-platform-widgets-ios.git',  :tag => '0.9.2'
```

## Usage

### SDK Initialisation

```swift
import Touch

// AppDelegate

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    Touch.shared.setup(clientId: "bRUVL8o0KiMIDRBKojxECtTWp",loginDelegate: self)
    return true
}

// ...

/// login request delegate - App should handle Touch SDK requests to sign in user 
extension AppDelegate: TouchLoginManagerProtocol{
    func requestLogin() {
        // Touch SDK will call this method when it needs user to sign in
        // Start user login flow. After user succesfully logs in, forward user id to Touch platform:
        Touch.shared.login(userId: "54321")
    }
}
```

### Widget Initalisation 

Create a widget with provided  Widget ID:

```swift
let widget = widget = Widget(TESTWIDGETID,location: "custom-link://")
```
Keep reference to the widget untill you don't need it anymore.

Under the hood Widget is a UIViewController and may be treated as such. Touch library provides methods that make it easy to add Widget's view into an existing view hierarchy, handle autolayout and refresh. 

### Add Widget to an empty  UIViewController

```swift
override func viewDidLoad() {
    super.viewDidLoad()
    widget.add(to: self)
}
```

### Add Widget into View (container)

If you've already setup a view  as a container for a Widget with autolayout constraints, then you can add the widget into it: 
```swift
    // Add widget into a inView
    widget.add(to: self, on: inView)
}
```

### Add Widget  as UITableViewCell 

Touch SDK Provides a helper class WidgetTableViewCell  to help adding a Widget into a table view. 

```swift
import UIKit
import Touch
class InTableViewController: UITableViewController {

    // keep a reference to a widget cell to reuse it and avoid unnecessary reloading of the widget.
    var widgetCell: WidgetTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44

        // register Widget tableView Cell
        WidgetTableViewCell.register(on: tableView)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create cells as usual. 
        // If you need a widget cell:
       
        // If you already have it - reuse it
        guard widgetCell == nil else { return widgetCell! }
        
        // or create one
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! WidgetTableViewCell
        // setup a widget cell
        cell.setup(widgetId: <widget_id>, location: "custom-link://", on: tableView)
        // keep a reference to it
        widgetCell = cell
        return cell
    }    
}
```

## User management
An app should inform  Touch SDK eveytime a user logs in into the app or logs out. 

### Login
After user logs in, call:
```swift
Touch.shared.login(userId:<user identifier string>)
```

### Logout
After user logs out, call: 
```swift
Touch.shared.logout()
```

### Login requests

If a Widget SDK needs a user id and the app did not provide one yet, then SDK will call TouchLoginManagerProtocol.requestLogin() method on loginDelegate provided during SDK initialisation. 
In that case the app should handle  the request: 
1. Start user login flow if needed
2. After user logs in provide user id to Touch sdk by calling Touch.shared.login(userId:<user identifier string>)


## License

Copyright Engagecraft Solutions
