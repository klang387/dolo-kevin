//
//  NewPostVC.swift
//  DoloChallenge
//
//  Created by Kevin Langelier on 2/26/18.
//  Copyright © 2018 Kevin Langelier. All rights reserved.
//

import UIKit
import YPImagePicker
import AVFoundation
import Photos
import CoreLocation

class NewPostVC: UIViewController {

// IBOutlets
    
    @IBOutlet weak var headlineField: UITextView!
    @IBOutlet weak var headlinePlaceholderLbl: UILabel!
    @IBOutlet weak var headlineView: UIView!
    @IBOutlet weak var bodyField: UITextView!
    @IBOutlet weak var bodyPlaceholderLbl: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var locationOptionalLbl: UILabel!
    @IBOutlet weak var cancelBtn: RoundedButton!
    @IBOutlet weak var postBtn: RoundedButton!
    @IBOutlet weak var cancelPostBtnStack: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headlineViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedPhotoView: UIImageView!
    @IBOutlet weak var photoStackView: UIStackView!
    
// Class variables
    
    var previousLines = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headlineField.delegate = self
        bodyField.delegate = self
        cancelBtn.layer.borderColor = UIColor.lightGray.cgColor
        headlineView.layer.borderColor = UIColor.lightGray.cgColor
        headlineView.layer.borderWidth = 1.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        headlineField.selectedTextRange = headlineField.textRange(from: headlineField.beginningOfDocument, to: headlineField.beginningOfDocument)
    }

// IBActions
    
    @IBAction func selectLocationPressed(_ sender: Any) {
        
        // Opens NearbyLocationsVC to select location if LocationServices are enabled, otherwise presents prompt to enable
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            performSegue(withIdentifier: "toNearbyLocationsVC", sender: nil)
        } else {
            let alertView = UIAlertController(title: "Location Services Disabled", message: "You need to enable Location Services in the app settings to use this feature.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Go", style: .default, handler: { (alert) in
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            })
            let action2 = UIAlertAction(title: "Nevermind", style: .cancel, handler: { (alert) in
                alertView.dismiss(animated: true, completion: nil)
            })
            alertView.addAction(action1)
            alertView.addAction(action2)
            present(alertView, animated: true, completion: nil)
        }
    }
    
    @IBAction func selectPhotoPressed(_ sender: Any) {
        
        // First checks for camera/library permissions, shows alert if access denied.
        
        // If allowed, uses YPImagePicker pod to select photo for attachment to post.
        
        if PHPhotoLibrary.authorizationStatus() == .denied && (AVCaptureDevice.authorizationStatus(for: .video) == .denied || AVAudioSession.sharedInstance().recordPermission() == .denied) {
            let alertView = UIAlertController(title: "Media Options Disabled", message: "You need to enable access to the Camera, Microphone, and Photo Library in the app settings to use this feature.", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Go", style: .default, handler: { (alert) in
                if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            })
            let action2 = UIAlertAction(title: "Nevermind", style: .cancel, handler: { (alert) in
                alertView.dismiss(animated: true, completion: nil)
            })
            alertView.addAction(action1)
            alertView.addAction(action2)
            present(alertView, animated: true, completion: nil)
        } else {
            let picker = YPImagePicker()
            picker.showsVideo = false
            picker.onlySquareImages = false
            picker.showsFilters = true
            picker.usesFrontCamera = true
            picker.didSelectImage = { [unowned picker, unowned self] img in
                self.photoStackView.isHidden = false
                self.selectedPhotoView.image = img
                picker.dismiss(animated: true, completion: nil)
            }
            picker.didSelectVideo = { videoData, videoThumbnailImage in
                picker.dismiss(animated: true, completion: nil)
            }
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func changePhotoPressed(_ sender: Any) {
        selectPhotoPressed(self)
    }
    
    @IBAction func removePhotoPressed(_ sender: Any) {
        photoStackView.isHidden = true
        selectedPhotoView.image = nil
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postPressed(_ sender: Any) {
        // Would upload to server
        
        guard let homeVC = presentingViewController as? HomeVC else { return }
        homeVC.icon.image = UIImage(named: "btnCheck")
        dismiss(animated: true, completion: nil)
    }
}

// TextView Delegate Functions

extension NewPostVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == headlineField {
            headlinePlaceholderLbl.isHidden = textView.text != ""
            postBtn.isEnabled = textView.text != ""
            postBtn.layer.borderColor = postBtn.isEnabled ? #colorLiteral(red: 0.853617847, green: 0.396854043, blue: 0.5513004065, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            postBtn.setTitleColor(postBtn.isEnabled ? #colorLiteral(red: 0.853617847, green: 0.396854043, blue: 0.5513004065, alpha: 1) : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), for: .normal)
            let lines = textView.numberOfLines()
            if lines != previousLines && lines <= 3 && lines > 0 {
                let change = lines - previousLines
                previousLines = lines
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.headlineViewHeight.constant += CGFloat(change * 18)
                    self.view.layoutIfNeeded()
                })
            }
        } else if textView == bodyField {
            bodyPlaceholderLbl.isHidden = textView.text != ""
        }
    }
}

// Constraint changes to update with keyboard

extension NewPostVC {
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let startFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let deltaY = endFrame.origin.y - startFrame.origin.y
        
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: { [unowned self] in
            print(deltaY)
            self.bottomConstraint.constant -= deltaY
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
}




