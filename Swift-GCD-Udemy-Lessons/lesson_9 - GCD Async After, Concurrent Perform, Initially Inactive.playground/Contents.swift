import UIKit
import PlaygroundSupport

class ViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.layer.cornerRadius = 10
        button.setTitle("Press to Second VC", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.systemYellow, for: .normal)
        return button
    }()
    
    private var isAcitve = false
    private let initiallyInactiveQueue = DispatchQueue(label: "CustomInitiallyInactiveQueue",
                                                       attributes: [.concurrent, .initiallyInactive])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemYellow
        
        self.view.addSubview(button)
        self.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        // Initially Queue
        initiallyInactiveQueue.async {
            for i in 0...20_000 {
                print("Current step: \(i)")
            }
        }
        //initiallyInactiveQueue.activate()
        //initiallyInactiveQueue.suspend()
        //initiallyInactiveQueue.resume()
        
        afterBlock(seconds: 5) {
            print("Async After Done!")
            DispatchQueue.main.async {
                self.view.backgroundColor = .systemPurple
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        button.center = view.center
    }
    
    @objc private func buttonAction() {
        print("Button Action Enter")
        
        let globalQueue = DispatchQueue.global(qos: .utility)
        globalQueue.async {
            print("Is main thread? : \(Thread.isMainThread)") // false
            
            // Concurrent Perform
            DispatchQueue.concurrentPerform(iterations: 3000) { (i) in
                print("Current step: \(i), Thread: \(Thread.current)") // use multiple threads, but not main thread! (because global queue used)
            }
            
            DispatchQueue.main.async {
                print("Concurrent Perform Done!")
                self.view.backgroundColor = .systemRed
            }
        }
        print("Button Action Exit")
    }
    
    // Async After
    private func afterBlock(seconds: Int, queue: DispatchQueue = DispatchQueue.global(), completion: @escaping () -> Void) {
        
        queue.asyncAfter(deadline: .now() + .seconds(seconds)) {
            completion()
        }
    }
}

let vc = ViewController()
PlaygroundPage.current.liveView = vc

