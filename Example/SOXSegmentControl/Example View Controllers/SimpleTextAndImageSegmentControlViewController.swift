//
//  SimpleTextAndImageSegmentControlViewController.swift
//  SOXSegmentControl
//
//  Created by Peter Hauke on 25.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import SOXSegmentControl


class SimpleTextAndImageSegmentControlViewController: UIViewController {

    //MARK: - Properties

    //MARK: - IBOutlets
    @IBOutlet private weak var segmentControl: SOXSegmentControl!

    //MARK: - Init&Co.
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSegmentControl()
    }

    //MARK: - Action Methods

    @IBAction func segmentControllAction(_ sender: SOXSegmentControl) {
        print("Selected segment with index \(sender.selectedSegmentPath)")
        print("Selected segment with index \(sender.selectedSegmentIndex)")
    }


}


//MARK: - Setup
extension SimpleTextAndImageSegmentControlViewController {

    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear
        segmentControl.textPosition = .bottom
        segmentControl.selectorType = .underlineBar

        let segments = [SOXSegmentDescriptor(title: "Segment A",
                                             imageName: "a.circle"),
                        SOXSegmentDescriptor(title: "Segment B",
                                             imageName: "b.circle"),
                        SOXSegmentDescriptor(title: "Segment C",
                                             imageName: "c.circle")]
        
        segmentControl.setSegmentDescriptors([segments])
    }
    
}
