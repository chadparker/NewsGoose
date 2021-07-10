//
//  MainVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import UIKit
import NGCore

class MainVC: UIViewController {

    @IBOutlet weak var pointsSegControl: UISegmentedControl!
    @IBOutlet weak var searchContainer: UIView!

    let postManager = PostManager()
    
    var searchVC: SearchVC!
    var postCollectionVC: PostCollectionVC!
    
    var pointsSegmentValue: Int {
        let pointsText = pointsSegControl.titleForSegment(at: pointsSegControl.selectedSegmentIndex)!
        return pointsText.intValueFromDigits
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: nil) { _ in
            self.postManager.loadLatestPosts()
        }
        updateSegmentControlFromUserDefaults()
    }

    func updateSegmentControlFromUserDefaults() {
        for i in 0 ..< pointsSegControl.numberOfSegments {
            let segmentPoints = pointsSegControl.titleForSegment(at: i)!.intValueFromDigits
            if segmentPoints == UserDefaults.pointsThreshold {
                pointsSegControl.selectedSegmentIndex = i
                pointsSegControl.sendActions(for: .valueChanged)
                break
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.delegate = self
            self.searchVC = searchVC
        } else if let postTableVC = segue.destination as? PostCollectionVC {
            postTableVC.pointsThreshold = pointsSegmentValue
            self.postCollectionVC = postTableVC
        }
    }
    
    @IBAction func pointsSelectionChanged(_ sender: UISegmentedControl) {
        UserDefaults.pointsThreshold = pointsSegmentValue
        postCollectionVC.pointsThreshold = pointsSegmentValue
    }
    
    @IBAction func showSearch(_ sender: UIButton) {
        searchContainer.isHidden = false
        searchVC.activate()
    }
}

extension MainVC: SearchVCDelegate {

    func hideSearch() {
        searchContainer.isHidden = true
    }
}
