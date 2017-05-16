//
//  ViewController.swift
//  GDCodeTest
//
//  Created by dushantsw on 2017-05-12.
//  Copyright © 2017 dushantsw. All rights reserved.
//

import UIKit
import SDWebImage

class ProfilesViewController: UIViewController {
    var profiles: [Profile]!
    private var currentProfile: Profile!
    private var currentIndex: Int = 0
    
    // Information view components
    @IBOutlet weak var nameAndAgeTextView: UILabel!
    @IBOutlet weak var distanceTextView: UILabel!
    @IBOutlet weak var onlineStatusTextView: UILabel!
    
    // Like button
    @IBOutlet weak var likeButton: LikeButton!
    
    // Image views
    @IBOutlet weak var firstImageView: ProfileImageView! 
    @IBOutlet weak var secondImageView: ProfileImageView!
    
    // Mark: - Life-cycle views
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if profiles != nil && (profiles?.count)! > 0 {
            currentProfile = self.profiles?[currentIndex]
            
            // Pre-fetch & Cache all images
            profiles.forEach { profile in
                let url = URL(string: Constants.mediaAbsURLWithMediaId(mediaId: profile.avatarId))
                SDWebImageDownloader.shared().downloadImage(with: url,
                                                            options: SDWebImageDownloaderOptions.continueInBackground,
                                                            progress: nil, completed: nil)
            }
        }
        
        self.loadCurrentProfile()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - IBActions
    @IBAction func onLikeButtonTapped(_ sender: Any) {
        // TODO: Go to next profile
        
        self.loadCurrentProfile()
    }
    
    @IBAction func onCloseButtonTapped(_ sender: Any) {
        self.loadCurrentProfile()
    }
    
    // Mark: - Private methods
    private func loadCurrentProfile() {
        self.currentIndex += 1;
        self.currentProfile = self.profiles?[currentIndex]
        
        if currentProfile != nil {
            nameAndAgeTextView.text = self.createNameAndAgeText(profile: currentProfile!)
            distanceTextView.text = currentProfile?.distance
            onlineStatusTextView.text = (currentProfile?.online)! ? "Online" : "Offline"
            firstImageView.loadImageWithMediaId(mediaId: (currentProfile?.avatarId!)!)
            
            let nextProfile: Profile = self.profiles[self.currentIndex + 1]
            secondImageView.loadImageWithMediaId(mediaId: nextProfile.avatarId)
        }
    }
    
    private func createNameAndAgeText(profile: Profile) -> String {
        return profile.name!.appending(", ").appendingFormat("%li", profile.age!)
    }
}

