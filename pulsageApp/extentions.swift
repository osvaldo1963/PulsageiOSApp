import UIKit
import Parse
import Font_Awesome_Swift

extension String {
    func getTextFromEmail() -> String{
        var token = self.components(separatedBy: "@")
        return token[0]
    }
    
    func gethashtags() -> [String]? {
        var result = [String]()
        let arrayOfText = self.components(separatedBy: " ")
        for arr in arrayOfText {
            let character = Array(arr)
            if character.contains("#") {
                let back = String(character)
                result.append(back)
            }
        }
        return result
    }
  
    var isEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
        let emailTest  = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
}

extension UIButton {
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
        self.layer.shadowRadius = 13
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension CAGradientLayer {
    func gradiendColorLayer(firstColor: UIColor, secondColor: UIColor, frame: CGRect) -> CAGradientLayer {
        let gradientLayer = self
        gradientLayer.frame = frame
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        return gradientLayer
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UINavigationController {
    
    func gradientBackground() {
        self.navigationBar.isTranslucent = true
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.backgroundColor = UIColor.clear
        self.navigationBar.tintColor = .white
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationWidth = self.navigationBar.frame.size.width
        let navigatioheight = self.navigationBar.frame.size.height
        let rightColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        let leftColor = UIColor(red:0.94, green:0.75, blue:0.60, alpha:1.0)
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: -20, width: navigationWidth, height: navigatioheight + statusBarHeight)
        gradientLayer.frame = CGRect(x: 0, y: -statusBarHeight, width: navigationWidth, height: navigatioheight + statusBarHeight)
        gradientLayer.colors = [rightColor.cgColor, leftColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.navigationBar.layer.insertSublayer(gradientLayer, at: 0)
        
        let attributes = [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue", size: 20)!, NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.titleTextAttributes = attributes
    }
}

extension Date {
    func timeAgoSinceDate(numericDates:Bool = false) -> String {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let date = self
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1y ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1m ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1w ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1d ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1h ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1mn ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!) seconds ago"
        } else {
            return "Just now"
        }
        
    }

}
extension UILabel {
    func addTextSpacing() {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedStringKey.kern, value: 1.15, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    func setCharacterSpacing(characterSpacing: CGFloat = 0.0) {
        
        guard let labelText = text else { return }
        
        let attributedString: NSMutableAttributedString
        if let labelAttributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelAttributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }
        
        // Character spacing attribute
        attributedString.addAttribute(NSAttributedStringKey.kern, value: characterSpacing, range: NSMakeRange(0, attributedString.length))
        
        attributedText = attributedString
    }
    
    func gradientColorVertical(top: UIColor, bottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [top.cgColor, bottom.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1.0)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIViewController {
    func simpleAlert(Message: String, title: String) {
        let alertcontroller = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alertcontroller.addAction(ok)
        self.present(alertcontroller, animated: true, completion: nil)
    }
    
    
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "i386", "x86_64":                          return "Simulator"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

extension UIImage {
    func imageIsNullOrNot() -> Bool {
        let size = CGSize(width: 0, height: 0)
        if self.size.width == size.width {
            return false
        } else {
            return true
        }
    }
}




extension UITabBarController {
    func setupMiddleButton(hidden: Bool) {
        
        let menuButton = BonceButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        menuButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(menuButton)
        menuButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        menuButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 58).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 58).isActive = true
        menuButton.backgroundColor = UIColor(red:0.87, green:0.36, blue:0.35, alpha:1.0)
        menuButton.layer.cornerRadius = 30
        menuButton.dropShadow()
        
        let icon = UIImage(named: "plusIcon")
        menuButton.setImage(icon, for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)
        
        self.view.layoutIfNeeded()
        
        if hidden {
            print(hidden)
            menuButton.isHidden = true
        } else {
            menuButton.isHidden = false
        }
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2
    }
    
}



