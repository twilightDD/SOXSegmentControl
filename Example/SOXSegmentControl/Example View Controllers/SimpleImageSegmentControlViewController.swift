//
//  SimpleImageSegmentControlViewController.swift
//  SOXSegmentControl
//
//  Created by Peter Hauke on 25.04.20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

import SOXSegmentControl

//MARK: - SimpleImageSegmentControlViewController
class SimpleImageSegmentControlViewController: UIViewController {

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
        print("Selected segment with index \(sender.selectedSegmentIndex)")
    }

}


//MARK: - Setup
extension SimpleImageSegmentControlViewController {

    private func setupSegmentControl() {
        segmentControl.backgroundColor = .clear
        segmentControl.textPosition = .bottom
        segmentControl.selectorType = .underlineBar

        let segments = [SOXSegmentDescriptor(imageName: "a.circle"),
                        SOXSegmentDescriptor(imageName: "b.circle"),
                        SOXSegmentDescriptor(imageName: "c.circle")]
        
        segmentControl.setSegmentDescriptors([segments])
    }
    
}
