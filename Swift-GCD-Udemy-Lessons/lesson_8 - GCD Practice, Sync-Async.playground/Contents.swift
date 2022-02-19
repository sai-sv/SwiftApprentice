import UIKit
import PlaygroundSupport

class FirstViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle("Press to Second VC", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.systemYellow, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title == "First VC"
        self.view.backgroundColor = .systemTeal
        
        self.view.addSubview(button)
        self.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        button.center = view.center
    }
    
    @objc private func buttonAction() {
        let secondVC = SecondViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
}

class SecondViewController: UIViewController {
    
    private let imageView =  UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Second VC"
        self.view.backgroundColor = .systemPink
        
        self.view.addSubview(imageView)
        loadImage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageView.frame = CGRect(x: 0, y: 0, width: 400, height: 400)
        imageView.center = view.center
    }
    
    private func loadImage() {
        let url = "https://www.planetware.com/wpimages/2019/10/russia-st-petersburg-top-attractions-saint-isaacs-cathedral.jpg"
        guard let imageURL = URL(string: url) else { return }
        
        let globalQueue = DispatchQueue.global(qos: .utility)
        
        // load async in global queue
        globalQueue.async {
            if let data = try? Data(contentsOf: imageURL) {
             
                // update async in main queue
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = UIImage(data: data)
                }
            }
        }
    }
}

let firstVC = FirstViewController()
let navVC = UINavigationController(rootViewController: firstVC)
PlaygroundPage.current.liveView = navVC
