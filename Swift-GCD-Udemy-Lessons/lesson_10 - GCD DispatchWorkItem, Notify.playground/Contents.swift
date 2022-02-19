import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

let url = URL(string: "https://www.planetware.com/wpimages/2019/10/russia-st-petersburg-top-attractions-peter-paul-fortress.jpg")!

let view = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
view.backgroundColor = .systemGray2

let imageView = UIImageView(frame: view.bounds)
imageView.contentMode = .scaleAspectFit

view.addSubview(imageView)
PlaygroundPage.current.liveView = view

// 1. Global Queue
func asyncLoadImageQueue() {
    let queue = DispatchQueue.global(qos: .utility)
    queue.async {
        if let imageData = try? Data(contentsOf: url) {
            // update in main
            DispatchQueue.main.async {
                imageView.image = UIImage(data: imageData)
            }
        }
    }
}

// 2. Work Item
func asyncLoadImageWorkItem() {
    var data: Data?
    let queue = DispatchQueue.global(qos: .utility)
    
    let workItem = DispatchWorkItem(qos: .userInteractive) {
        print(Thread.current)
        data = try? Data(contentsOf: url)
    }
    
    workItem.notify(queue: .main) { // update in main
        if let imageData = data {
            print(Thread.current)
            imageView.image = UIImage(data: imageData)
        }
    }
    
    queue.async(execute: workItem)
}

// 3. URLSession
func asyncLoadImageURLSession() {
    let task = URLSession.shared.dataTask(with: url) { (data, _, _) in
        print(Thread.current)
        if let imageData = data {
            // update in main
            DispatchQueue.main.async {
                print(Thread.current)
                imageView.image = UIImage(data: imageData)
            }
        }
    }
    task.resume()
}

//asyncLoadImageQueue()
//asyncLoadImageWorkItem()
asyncLoadImageURLSession()
