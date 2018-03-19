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
        
    }
}

extension UIView {
    
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


func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension String {
    func NSRangeFromRange(range: Range<String.Index>) -> NSRange {
        let utf16view = self.utf16
        let from = String.UTF16View.Index(range.lowerBound, within: utf16view)!
        let to = String.UTF16View.Index(range.upperBound, within: utf16view)!
        
        return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
        //return NSMakeRange(utf16view.distance(from: utf16view.startIndex, to: from), utf16view.distance(from: from, to: to))
    }
    
    mutating func dropTrailingNonAlphaNumericCharacters() {
        let nonAlphaNumericCharacters = NSCharacterSet.alphanumerics.inverted
        let characterArray = components(separatedBy: nonAlphaNumericCharacters)
        if let first = characterArray.first {
            self = first
        }
    }
}

extension UITextView {
    
    
    public func resolveHashTags(possibleUserDisplayNames:[String]? = nil) {
        
        let schemeMap = [
            "#":"hash",
            "@":"mention"
        ]
        
        // Separate the string into individual words.
        // Whitespace is used as the word boundary.
        // You might see word boundaries at special characters, like before a period.
        // But we need to be careful to retain the # or @ characters.
        let words = self.text.components(separatedBy: NSCharacterSet.whitespacesAndNewlines)
        let attributedString = attributedText.mutableCopy() as! NSMutableAttributedString
        
        // keep track of where we are as we interate through the string.
        // otherwise, a string like "#test #test" will only highlight the first one.
        var bookmark = text.startIndex
        
        // Iterate over each word.
        // So far each word will look like:
        // - I
        // - visited
        // - #123abc.go!
        // The last word is a hashtag of #123abc
        // Use the following hashtag rules:
        // - Include the hashtag # in the URL
        // - Only include alphanumeric characters.  Special chars and anything after are chopped off.
        // - Hashtags can start with numbers.  But the whole thing can't be a number (#123abc is ok, #123 is not)
        for word in words {
            
            var scheme:String? = nil
            
            if word.hasPrefix("#") {
                scheme = schemeMap["#"]
            } else if word.hasPrefix("@") {
                scheme = schemeMap["@"]
            }
            
            // Drop the # or @
            var wordWithTagRemoved = String(word.dropFirst())
            
            // Drop any trailing punctuation
            wordWithTagRemoved.dropTrailingNonAlphaNumericCharacters()
            
            // Make sure we still have a valid word (i.e. not just '#' or '@' by itself, not #100)
            guard let schemeMatch = scheme, Int(wordWithTagRemoved) == nil && !wordWithTagRemoved.isEmpty
                else { continue }
            
            let remainingRange = Range(bookmark..<text.endIndex)
            
            // URL syntax is http://123abc
            
            // Replace custom scheme with something like hash://123abc
            // URLs actually don't need the forward slashes, so it becomes hash:123abc
            // Custom scheme for @mentions looks like mention:123abc
            // As with any URL, the string will have a blue color and is clickable
            
            if let matchRange = text.range(of: word, options: .literal, range: remainingRange),
                let escapedString = wordWithTagRemoved.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                attributedString.addAttribute(NSAttributedStringKey.link, value: "\(schemeMatch):\(escapedString)", range: text.NSRangeFromRange(range: matchRange))
            }
            
            // just cycled through a word. Move the bookmark forward by the length of the word plus a space
            bookmark = text.index(bookmark, offsetBy: word.dropFirst().count)
        }
        
        self.attributedText = attributedString
    }
    
    func convertHashtags(text: String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: text)
        attrString.beginEditing()
        // match all hashtags
        do {
            // Find all the hashtags in our string
            let regex = try NSRegularExpression(pattern: "(?:\\s|^)(#(?:[a-zA-Z].*?|\\d+[a-zA-Z]+.*?))\\b", options: NSRegularExpression.Options.anchorsMatchLines)
            let results = regex.matches(in: text ,options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, text.characters.count))
            let array = results.map { (text as NSString).substring(with: $0.range) }
            for hashtag in array {
                // get range of the hashtag in the main string
                let range = (attrString.string as NSString).range(of: hashtag)
                // add a colour to the hashtag
                attrString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue , range: range)
            }
            attrString.endEditing()
        }
        catch {
            attrString.endEditing()
        }
        return attrString
    }
}

extension UITextView {
    
    func resolveHash() {
        
        // turn string in to NSString
        let nsText = NSString(string: self.text)
        
        // this needs to be an array of NSString.  String does not work.
        let words = nsText.components(separatedBy: CharacterSet(charactersIn: "#ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_").inverted)
        
        // you can staple URLs onto attributed strings
        let attrString = NSMutableAttributedString()
        attrString.setAttributedString(self.attributedText)
        
        // tag each word if it has a hashtag
        for word in words {
            if word.count < 3 {
                continue
            }
            
            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            if word.hasPrefix("#") {
                
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.range(of: word as String)
                
                // drop the hashtag
                let stringifiedWord = word.dropFirst()
                if let firstChar = stringifiedWord.unicodeScalars.first, NSCharacterSet.decimalDigits.contains(firstChar) {
                    // hashtag contains a number, like "#1"
                    // so don't make it clickable
                } else {
                    // set a link for when the user clicks on this word.
                    // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                    // note:  since it's a URL now, the color is set to the project's tint color
                    attrString.addAttribute(NSAttributedStringKey.link, value: "hash:\(stringifiedWord)", range: matchRange)
                }
                
            }
        }
        
        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
        self.attributedText = attrString
    }
}



