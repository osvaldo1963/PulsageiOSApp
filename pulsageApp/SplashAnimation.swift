import UIKit
import Parse

class SplashAnimation: UIViewController {
    
    fileprivate lazy var splash: UIView = {
        let vs = SplashScreen(frame: self.view.bounds)
        return vs
    }()
    
    fileprivate lazy var imageview: UIImageView = {
        let imview = UIImageView()
        imview.image = #imageLiteral(resourceName: "spBack")
        imview.contentMode = .scaleAspectFill
        imview.clipsToBounds = true
        imview.frame = self.view.bounds
        return imview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.insertSubview(self.imageview, at: 0)
        self.navigationController?.gradientBackground()
        self.navigationController?.navigationBar.isHidden = true
        self.view.addSubview(self.splash)
        let when = DispatchTime.now() + 1.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            if PFUser.current() != nil {
                let tabBarViewcontroller = TabBar()
                self.navigationController?.pushViewController(tabBarViewcontroller, animated: true)
            } else {
                let presenatationView = Presentation()
                self.navigationController?.pushViewController(presenatationView, animated: true)
            }
        }
    }
}
