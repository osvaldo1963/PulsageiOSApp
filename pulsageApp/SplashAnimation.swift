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
        self.view.addSubview(self.splash)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.gradientBackground()
        self.navigationController?.navigationBar.isHidden = true
       
        let when = DispatchTime.now() + 1.7
        DispatchQueue.main.asyncAfter(deadline: when) {
            if PFUser.current() != nil {
                guard let userid = PFUser.current()?.objectId else {return}
                PFPush.subscribeToChannel(inBackground: userid, block: { (success, error) in })
                let tabBarViewcontroller = TabBar()
                self.present(tabBarViewcontroller, animated: true, completion: nil)
                
            } else {
                let presenatationView = Presentation()
                self.navigationController?.pushViewController(presenatationView, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
