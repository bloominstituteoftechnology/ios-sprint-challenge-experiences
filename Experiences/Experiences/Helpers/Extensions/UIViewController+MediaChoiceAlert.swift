//
//  UIViewController+MediaChoiceAlert.swift
//  Experiences
//
//  Created by Jessie Ann Griffin on 5/15/20.
//  Copyright © 2020 Jessie Griffin. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentMediaOptionsAlertController(title: String? = "Choose Media Type",
                                            message: String? = "How would you like to record your experience?",
                                            dismissActionCompletion: ((UIAlertAction) -> Void)? = nil,
                                            completion: (() -> Void)? = nil) {
        
        guard let imageVC = self.storyboard?.instantiateViewController(withIdentifier: "ImagePostViewController"),
            let audioVC = self.storyboard?.instantiateViewController(withIdentifier: "AudioPostViewController"),
            let videoVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoPostViewController") else { return }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: dismissActionCompletion)
        let imageAction = UIAlertAction(title: "Choose a photo.", style: .default) { action in
            self.present(imageVC, animated: true)
        }
        let audioAction = UIAlertAction(title: "Record audio.", style: .default) { action in
            self.present(audioVC, animated: true, completion: nil)

        }
        let videoAction = UIAlertAction(title: "Take a video.", style: .default) { action in
            self.present(videoVC, animated: true, completion: nil)

        }
        alertController.addAction(dismissAction)
        alertController.addAction(imageAction)
        alertController.addAction(audioAction)
        alertController.addAction(videoAction)

        
        present(alertController, animated: true, completion: completion)
    }
    
    func addTitleOrCaptionAlertController() {
//        let alert = UIAlertController(title: "Add a Title or Caption",
//                                      message: "Describe your experience!",
//                                      preferredStyle: .alert)
//        
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        
//        alert.addTextField { textField in
//            textField.placeholder = "Title:"
//        }
//        
//        alert.addAction(UIAlertAction(title: "Submit", style: .default, handler: { action in
//            if let videoTitle = alert.textFields?.first?.text {
//                self.videoPostController?.addVideo(withTitle: videoTitle, andURL: outputFileURL)
//            }
//            NotificationCenter.default.post(name: .newVideoAddedAddedNotificationName, object: self)
//        }))
//        self.present(alert, animated: true)
    }
}

