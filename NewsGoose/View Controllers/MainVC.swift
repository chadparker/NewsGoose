//
//  MainVC.swift
//  NewsGoose
//
//  Created by Chad Parker on 3/29/21.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var pointsSegControl: UISegmentedControl!
    @IBOutlet weak var searchContainer: UIView!
    var searchVC: SearchVC!
    var postTableVC: PostTableVC!
    
    var pointsSegmentValue: Int {
        let pointsText = pointsSegControl.titleForSegment(at: pointsSegControl.selectedSegmentIndex)!
        let digitsString = pointsText.replacingOccurrences(of: "\\D",
                                                           with: "",
                                                           options: .regularExpression,
                                                           range: pointsText.startIndex..<pointsText.endIndex)
        return Int(digitsString) ?? 0
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let searchVC = segue.destination as? SearchVC {
            searchVC.delegate = self
            self.searchVC = searchVC
        } else if let postTableVC = segue.destination as? PostTableVC {
            postTableVC.pointThreshold = pointsSegmentValue
            self.postTableVC = postTableVC
        }
    }
    
    @IBAction func pointsSelectionChanged(_ sender: UISegmentedControl) {
        postTableVC.filter(points: pointsSegmentValue)
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
