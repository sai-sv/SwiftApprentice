//
//  ViewController.swift
//  MyLocations
//
//  Created by Sergei Sai on 30.01.2022.
//

import UIKit
import CoreLocation
import CoreData
import AudioToolbox

class CurrentLocationViewController: UIViewController {
    
    // Core Data
    var managedObjectContext: NSManagedObjectContext!
    
    // Location
    let locationManager = CLLocationManager()
    var location: CLLocation?
    var updatingLocation = false
    var lastLocationError: Error?
    
    // Geocoding
    let geocoder = CLGeocoder()
    var placemark: CLPlacemark?
    var performingReverseGeocoding = false
    var lastGeocodingError: Error?
    
    // Sound
    var soundID: SystemSoundID = 0
    
    var timer: Timer?
    
    var isLogoVisible = false
    lazy var logoButton: UIButton = {
        // NOTE: The button is a “custom” type UIButton, meaning that it has no title text or other frills.
        let button = UIButton(type: .custom)
        button.setBackgroundImage(UIImage(named: "Logo"), for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(getLocation), for: .touchUpInside)
        button.center.x = self.view.bounds.midX
        button.center.y = 220
        return button
    }()
    
    @IBOutlet weak var latitudeTextLabel: UILabel!
    @IBOutlet weak var longitudeTextLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
        loadSoundEffect("Sound.caf")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TagLocation" {
            let dstVC = segue.destination as! LocationDetailsViewController
            dstVC.coordinate = location!.coordinate
            dstVC.placemark = placemark
            dstVC.managedObjectContext = managedObjectContext
        }
    }
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func updateLabels() {
        if let location = self.location {
            latitudeLabel.isHidden = false
            longitudeLabel.isHidden = false
            
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            tagButton.isHidden = false
            messageLabel.text = ""
            
            // Geocoding
            if let placemark = placemark {
                addressLabel.text = string(from: placemark)
            } else if performingReverseGeocoding {
                addressLabel.text = "Searching for Address..."
            } else if lastGeocodingError != nil {
                addressLabel.text = "Error Finding Address"
            } else {
                addressLabel.text = "No Address Found"
            }
        } else {
            latitudeLabel.isHidden = true
            longitudeLabel.isHidden = true
            
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            tagButton.isHidden = true
            
            let statusMessage: String
            if let error = lastLocationError as NSError? {
                if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                    statusMessage = "Location Services Disabled"
                } else {
                    statusMessage = "Error Getting Location"
                }
            } else if !CLLocationManager.locationServicesEnabled() {
                statusMessage = "Location Services Disabled"
            } else if updatingLocation {
                statusMessage = "Searching..."
            } else {
                // Startup Time OR No coordinates or Error message to display
                statusMessage = ""
                showLogoView()
            }
            messageLabel.text = statusMessage
        }
        
        configureGetButton()
    }
    
    func configureGetButton() {
        let spinnerTag = 1000
        
        if updatingLocation {
            getButton.setTitle("Stop", for: .normal)
            
            // spinner
            if view.viewWithTag(spinnerTag) == nil {
                let activityIndicator = UIActivityIndicatorView(style: .medium)
                activityIndicator.tag = spinnerTag
                activityIndicator.center = messageLabel.center
                activityIndicator.center.y = activityIndicator.bounds.height / 2 + 25
                activityIndicator.startAnimating()
                containerView.addSubview(activityIndicator)
            }
        } else {
            getButton.setTitle("Get My Location", for: .normal)
            
            if let activityIndicator = view.viewWithTag(spinnerTag) {
                activityIndicator.removeFromSuperview()
            }
        }
    }
    
    func string(from placemark: CLPlacemark) -> String {
        var line1 = ""
        line1.add(text: placemark.subThoroughfare)
        line1.add(text: placemark.thoroughfare, separatedBy: " ")
        
        var line2 = ""
        line2.add(text: placemark.locality)
        line2.add(text: placemark.administrativeArea, separatedBy: " ")
        line2.add(text: placemark.postalCode, separatedBy: " ")
        
        line1.add(text: line2, separatedBy: "\n")
        return line1
    }
    
    func startLocationManager() {
        if !CLLocationManager.locationServicesEnabled() {
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        updatingLocation = true
        
        timer = Timer.scheduledTimer(timeInterval: 60,
                                     target: self, selector: #selector(didTimeout),
                                     userInfo: nil, repeats: false)
    }
    
    func stopLocationManager() {
        if !updatingLocation {
            return
        }
        
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        updatingLocation = false
        
        if let timer = timer {
            timer.invalidate()
        }
    }
    
    func showLogoView() {
        if isLogoVisible {
            return
        }
        
        isLogoVisible = true
        containerView.isHidden = true
        view.addSubview(logoButton)
    }
    
    func hideLogoView() {
        if !isLogoVisible {
            return
        }
        
        isLogoVisible = false
        containerView.isHidden = false
        containerView.center.x = view.bounds.size.width * 2
        containerView.center.y = 40 + containerView.bounds.height / 2
        
        let centerX = view.bounds.midX
        
        let panelMover = CABasicAnimation(keyPath: "position")
        panelMover.isRemovedOnCompletion = false
        panelMover.fillMode = .forwards
        panelMover.duration = 0.6
        panelMover.fromValue = NSValue(cgPoint: containerView.center)
        panelMover.toValue = NSValue(cgPoint: CGPoint(x: centerX, y: containerView.center.y))
        panelMover.timingFunction = CAMediaTimingFunction(name: .easeOut)
        panelMover.delegate = self
        containerView.layer.add(panelMover, forKey: "panelMover")
        
        let logoMover = CABasicAnimation(keyPath: "position")
        logoMover.isRemovedOnCompletion = false
        logoMover.fillMode = .forwards
        logoMover.duration = 0.5
        logoMover.fromValue = NSValue(cgPoint: logoButton.center)
        logoMover.toValue = NSValue(cgPoint: CGPoint(x: -centerX, y: logoButton.center.y))
        logoMover.timingFunction = CAMediaTimingFunction(name: .easeIn)
        logoButton.layer.add(logoMover, forKey: "logoMover")
        
        let logoRotator = CABasicAnimation(keyPath: "transform.rotation.z")
        logoRotator.isRemovedOnCompletion = false
        logoRotator.fillMode = .forwards
        logoRotator.duration = 0.5
        logoRotator.fromValue = 0.0
        logoRotator.toValue = -2 * Double.pi
        logoRotator.timingFunction = CAMediaTimingFunction(name: .easeIn)
        logoButton.layer.add(logoRotator, forKey: "logoRotator")
    }
    
    // MARK: - Actions
    @IBAction func getLocation() {
        let status = locationManager.authorizationStatus
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if status == .denied || status == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        if isLogoVisible {
            hideLogoView()
        }
        
        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodingError = nil
            startLocationManager()
        }
        updateLabels()
    }
    
    @objc func didTimeout() {
        print("*** Time out")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            updateLabels()
        }
    }
    
}

// MARK: - Core Location Delegate
extension CurrentLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("Did update location: \(newLocation)")
        
        if newLocation.timestamp.timeIntervalSinceNow < -5 { // cached location
            return
        }
        if newLocation.horizontalAccuracy < 0 {
            return
        }
        
        // distance between the new reading and the previous reading
        var distance = CLLocationDistance(Double.greatestFiniteMagnitude)
        if let location = location {
            distance = newLocation.distance(from: location)
        }
        
        if location == nil || location!.horizontalAccuracy > newLocation.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
            
            if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
                print("*** We're done!")
                stopLocationManager()
                
                if distance > 0 {
                    performingReverseGeocoding = false
                }
            }
            updateLabels()
            
            // Start Geocoding
            if !performingReverseGeocoding {
                print("*** Going to geocode")
                performingReverseGeocoding = true
                geocoder.reverseGeocodeLocation(newLocation) { placemarks, error in
                    self.lastGeocodingError = error
                    if error == nil, let places = placemarks, !places.isEmpty {
                        // Play Sound
                        if self.placemark == nil {
                            print("FIRST TIME!")
                            self.playSoundEffect()
                        }
                        
                        self.placemark = places.last!
                    } else {
                        self.placemark = nil
                    }
                    self.performingReverseGeocoding = false
                    self.updateLabels()
                }
            }
            // End Geocoding
            
        } else if distance < 1 {
            let timeInterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeInterval > 10 {
                print("*** We're done!")
                stopLocationManager()
                updateLabels()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did fail with error: \(error.localizedDescription)")
        
        // • CLError.locationUnknown — the location is currently unknown, but Core Location will keep trying.
        // • CLError.denied — the user denied the app permission to use location services.
        // • CLError.network — there was a network-related error.
        if (error as NSError).code == CLError.locationUnknown.rawValue {
            return
        }
        
        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }
}

// MARK: - Animation Delegate
extension CurrentLocationViewController: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        containerView.layer.removeAllAnimations()
        containerView.center.x = view.bounds.size.width / 2
        containerView.center.y = 40 + containerView.bounds.size.height / 2
        
        logoButton.layer.removeAllAnimations()
        logoButton.removeFromSuperview()
    }
}

// MARK: - Sound
extension CurrentLocationViewController {
    
    func loadSoundEffect(_ name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else { return }
        let fileURL = URL(fileURLWithPath: path, isDirectory: false)
        
        if case let error = AudioServicesCreateSystemSoundID(fileURL as CFURL, &soundID),
            error != kAudioServicesNoError {
            print("Error code \(error) loading sound: \(path)")
        }
    }
    
    func unloadSoundEffect() {
        AudioServicesDisposeSystemSoundID(soundID)
        soundID = 0
    }
    
    func playSoundEffect() {
        AudioServicesPlaySystemSound(soundID)
    }
}
