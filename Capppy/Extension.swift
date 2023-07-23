//
//  Extension.swift
//  Capppy
//
//  Created by Jana Vac on 06.03.2023.
//
import Foundation
import SDWebImage



extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}


extension UIImageView {
    func addBlackGradientLayer(frame: CGRect, colors:[UIColor]){
        let gradient = CAGradientLayer()
        gradient.frame = frame
        gradient.locations = [0.5, 1.0]
        
        gradient.colors = colors.map{$0.cgColor}
        self.layer.addSublayer(gradient)
    }
}

extension String {
    func estimateFrameForText(_ text: String) -> CGRect{
        let size = CGSize(width: 280, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17)], context: nil)
    }
}


func timeAgoSinceDate(_ date:Date, currentDate:Date, numericDates:Bool) -> String {
    let calendar = Calendar.current
    let now = currentDate
    let earliest = (now as NSDate).earlierDate(date)
    let latest = (earliest == now) ? date : now
    let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
    
    if (components.year! >= 2) {
        return "před \(components.year!) lety"
    } else if (components.year! >= 1){
        if (numericDates){ return "před rokem"
        } else { return "minulý rok" }
    } else if (components.month! >= 2) {
        return "před \(components.month!) měsíci"
    } else if (components.month! >= 1){
        if (numericDates){ return "před měsícem"
        } else { return "minulý měsíc" }
    } else if (components.weekOfYear! >= 2) {
        return "před \(components.weekOfYear!) týdny"
    } else if (components.weekOfYear! >= 1){
        if (numericDates){ return "před týdnem"
        } else { return "minulý týden" }
    } else if (components.day! >= 2) {
        return "před \(components.day!) dny"
    } else if (components.day! >= 1){
        if (numericDates){ return "včera"
        } else { return "včera" }
    } else if (components.hour! >= 2) {
        return "před \(components.hour!) hodinami"
    } else if (components.hour! >= 1){
        if (numericDates){ return "před hodinou"
        } else { return "před hodinou" }
    } else if (components.minute! >= 2) {
        return "před \(components.minute!) minutami"
    } else if (components.minute! >= 1){
        if (numericDates){ return "před minutou"
        } else { return "před minutou" }
    } else if (components.second! >= 3) {
        return "před \(components.second!) sekundami"
    } else { return "Právě teď" }
}


extension UIImageView {
    func loadImage(_ urlString: String?, onSuccess: ((UIImage) -> Void)? = nil) {
        self.image = UIImage()
        guard let string = urlString else { return }
        guard let url = URL(string: string) else { return }
        self.sd_setImage(with: url) { (image, error, type, url) in
            if onSuccess != nil, error == nil {
                onSuccess!(image!)
            }
        }
    }
}

extension String {
    func isValidEmail() -> Bool {
        // Základní ověření správného formátu emailové adresy.
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension Double {
    func convertDate() -> String {
        var string = ""
        let date: Date = Date(timeIntervalSince1970: self)
        let calendrier = Calendar.current
        let formatter = DateFormatter()
        if calendrier.isDateInToday(date) {
            string = ""
            formatter.timeStyle = .short
        } else if calendrier.isDateInYesterday(date) {
            string = "Včera: "
            formatter.timeStyle = .short
        } else {
            formatter.dateStyle = .short
        }
        let dateString = formatter.string(from: date)
        return string + dateString
    }
}


extension String {
    var hashString: Int {
        let unicodeScalars = self.unicodeScalars.map { $0.value }
        return unicodeScalars.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

