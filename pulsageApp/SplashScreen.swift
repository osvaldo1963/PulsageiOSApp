import UIKit

class SplashScreen: UIView {
    
    fileprivate lazy var icon: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "pulsageIcon.png")
        return imageview
    }()
    
    fileprivate lazy var PulsageText: UILabel = {
        let label = UILabel()
        label.text = "PULSAGE"
        label.textColor = .white
        label.font = UIFont(name: "Segoe UI", size: 0)
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        label.setCharacterSpacing(characterSpacing: 8.0)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //Background imageview
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "spBack.jpg")
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        self.insertSubview(backgroundImage, at: 0)
        ///
        
        //Icon props
        self.addSubview(self.icon)
        self.icon.frame = CGRect(x: frame.size.width / 2 - 50, y: frame.size.height / 2 - 50, width: 100, height: 100)
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.5
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.9
        pulse.damping = 1.0
        self.icon.layer.add(pulse, forKey: "pulse")
        ///
        
        //Pulsage Text Props
        self.addSubview(self.PulsageText)
        self.PulsageText.frame = CGRect(x: 0, y: frame.size.height / 2 + 50, width: frame.size.width , height: 100)
        ///
        
        //alpha action
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            UIView.animate(withDuration: 0.4, delay: 0.7, options: .curveEaseIn, animations: {
                self.alpha = 0
                self.icon.frame = CGRect(x: 0, y: frame.size.height / 4, width: frame.size.width, height: frame.size.height / 2)
            }, completion: nil)
        }
        ///
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
