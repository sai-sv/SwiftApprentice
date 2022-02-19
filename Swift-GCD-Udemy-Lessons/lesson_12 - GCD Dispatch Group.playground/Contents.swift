import UIKit
import PlaygroundSupport

let urls = ["https://www.planetware.com/wpimages/2020/01/florida-best-time-to-visit-best-month-to-visit.jpg",
            "https://www.planetware.com/wpimages/2020/01/florida-best-time-to-visit-best-time-of-year-to-go.jpg",
            "https://www.planetware.com/wpimages/2020/01/florida-best-time-to-visit-cities-with-the-best-weather.jpg",
            "https://www.planetware.com/wpimages/2020/01/florida-best-time-to-visit-best-time-to-visit-miami.jpg",
            "https://www.planetware.com/wpimages/2020/01/florida-best-time-to-visit-best-time-visit-orlando.jpg",
            "https://www.planetware.com/wpimages/2020/01/florida-best-time-to-visit-best-time-to-visit-key-west-florida-keys.jpg",
            "https://www.planetware.com/wpimages/2020/01/florida-best-time-to-visit-cheapest-time-visit-florida.jpg",
            "https://www.planetware.com/wpimages/2020/01/florida-best-time-to-visit-best-time-year-visit-southern-florida.jpg"]
var images = [UIImage]()
var imageViews = [UIImageView]()

func loadImage(url: URL, loadQueue: DispatchQueue, updateQueue: DispatchQueue, completion: @escaping (Result<UIImage, Error>) -> Void) {
    
    loadQueue.async {
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                updateQueue.async {
                    completion(.success(image))
                }
            }
        } catch let error {
            updateQueue.async {
                completion(.failure(error))
            }
        }
    }
}

func loadImages() {
    
    let group = DispatchGroup()
    
    for i in 0..<urls.count {
        group.enter()
        loadImage(url: URL(string: urls[i])!, loadQueue: .global(), updateQueue: .main) { (result) in
            switch result {
            case .success(let image):
                images.append(image)
            case .failure(let error):
                print(error.localizedDescription)
            }
            group.leave()
        }
    }
    
    group.notify(queue: .main) {
        for i in 0..<images.count {
            imageViews[i].image = images[i]
        }
    }
}

class CollectionView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let size = CGSize(width: 200.0, height: 200.0)
        let x: CGFloat = 50.0
        let y: CGFloat = 0.0
        let space: CGFloat = 5.0
        
        for i in 0..<4 {
            imageViews.append(UIImageView(frame: CGRect(x: x, y: y + ((size.height + space) * CGFloat(i)), width: size.width, height: size.height)))
        }
        for i in 0..<4 {
            imageViews.append(UIImageView(frame: CGRect(x: x + size.width + space, y: y + ((size.height + space) * CGFloat(i)), width: size.width, height: size.height)))
        }
        for iv in imageViews {
            iv.contentMode = .scaleAspectFit
            self.addSubview(iv)
        }
        
        self.backgroundColor = .systemYellow
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

let view = CollectionView(frame: CGRect(x: 0, y: 0, width: 500, height: 800))
PlaygroundPage.current.liveView = view

loadImages()
