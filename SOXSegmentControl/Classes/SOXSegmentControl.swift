//
//  SOXSegment.swift
//  Tell My Friend
//
//  Created by Peter Hauke on 19.04.20.
//  Copyright © 2020 Peter Hauke. All rights reserved.
//

//  Created by Wasim Malek on 27/05/19.
//  Copyright © 2019 Wasim Malek. All rights reserved.
//

import Foundation
import UIKit

//MARK: - SOXSegmentDescriptor
struct SOXSegmentDescriptor {
    var buttonTitle: String?
    var buttonImageName: String?

    var selectedTextColor: UIColor = .label
    var selectedTintColor: UIColor = .label
    var unSelectedTextColor: UIColor = .lightGray
    var unSelectedTintColor: UIColor = .lightGray
    var underlineBarColor: UIColor = .darkGray

    var selectedFont : UIFont = UIFont.systemFont(ofSize: 15)
    var unSelectedFont : UIFont = UIFont.systemFont(ofSize: 15)
}

//MARK: SOXSegmentDescriptor - Convenient Init
extension SOXSegmentDescriptor {

    init(buttonTitle: String?,
         buttonImageName: String?,
         selectedColor: UIColor,
         unSelectedColor: UIColor = .lightGray) {

        self.buttonTitle = buttonTitle
        self.buttonImageName = buttonImageName

        self.selectedTextColor = selectedColor
        self.selectedTintColor = selectedColor
        self.underlineBarColor = selectedColor

        self.unSelectedTextColor = unSelectedColor
        self.unSelectedTintColor = unSelectedColor
    }
}

//MARK: -
//MARK: - SOXSegmentControl
open class SOXSegmentControl: UIControl {
    
    //MARK: Enums
    enum SegmentType: Int {
        case normal
        case imageOnTop
        case imageOnly
    }
    
    enum SelectorType: Int {
        case normal
        case underlineBar
    }
    
    //MARK: - Lets and Vars
    //MARK: Properties
    var onValueChanged: ((_ index: Int)->())?
    var selectedSegmentIndex: Int = 0  {
        didSet {
            print("\(#function) selectedSegmentIndex didSet to \(selectedSegmentIndex)")
        } }

    var type: SOXSegmentControl.SegmentType = .normal { didSet { updateView() } }
    var selectorType: SOXSegmentControl.SelectorType = .normal { didSet { updateView() } }

    var buttonTitles = [String]() { didSet { updateView() } }
    var buttonImageNames = [String]() { didSet { updateView() } }
    var segmentDescriptors: [SOXSegmentDescriptor]? { didSet { updateView() } }

    var animateUnderlineBarMovement: Bool = true

    // UI
    var bottomBarHeight : CGFloat = 5.0  { didSet { updateView() } }

    var borderWidth: CGFloat = 0 { didSet { layer.borderWidth = borderWidth } }
    var borderColor: UIColor = .clear { didSet { layer.borderColor = borderColor.cgColor } }
    var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius } }

    var selectedTextColor: UIColor = .label { didSet { updateView() } }
    var selectedTintColor: UIColor = .label { didSet { updateView() } }
    var unSelectedTextColor: UIColor = .lightGray { didSet { updateView() } }
    var unSelectedTintColor: UIColor = .lightGray { didSet { updateView() } }
    var underlineBarColor: UIColor = .darkGray { didSet { updateView() } }
    
    var selectedFont : UIFont = UIFont.systemFont(ofSize: 15) { didSet { updateView() } }
    var unSelectedFont : UIFont = UIFont.systemFont(ofSize: 15) { didSet { updateView() } }

    var isUnderlineBarRounded: Bool = false {
        didSet {
            if isUnderlineBarRounded == true {
                underlineBarView.layer.cornerRadius = underlineBarView.frame.height/2
            }
            updateView()
        }
    }

    var isSegmentRounded: Bool = false {
        didSet {
            if isSegmentRounded == true {
                layer.cornerRadius = frame.height/2
            }
            updateView()
        }
    }

    //MARK: - Private Properties
    private var buttons = [UIButton]()
    private var underlineBarView: UIView!

    //MARK: - Open Methods
    open override func layoutSubviews() {
        super.layoutSubviews()

        updateView()

        let _animated = animateUnderlineBarMovement
        animateUnderlineBarMovement = false
        setSelectedIndex(selectedSegmentIndex)
        animateUnderlineBarMovement = _animated
    }




    open func setSelectedIndex(_ index: Int) {
        selectedSegmentIndex = index

        for (index, button) in buttons.enumerated() {
            button.tintColor = unSelectedTintColor(forButtonAtIndex: index)
            button.setTitleColor(unSelectedTextColor(forButtonAtIndex: index),
                                 for: .normal)

            // if selectedButton
            if button.tag == selectedSegmentIndex {
                // Change Colors
                button.tintColor = selectedTintColor(forButtonAtIndex: index)
                button.setTitleColor(selectedTextColor(forButtonAtIndex: index),
                                     for: .normal)

                // Move underlineBar
                moveUnderlineBar(toIndex: index)
            }
        }
    }

    open func changeSelectedColor(_ color: UIColor) {
        underlineBarView.backgroundColor = color
    }

    //MARK: - Private Methods
    private func updateView() {
        clipsToBounds = true
        buttons.removeAll()
        subviews.forEach( { $0.removeFromSuperview() } )
        
        if type == .normal {
            buttons = getButtonsForNormalSegment(hasTopImage: false)
        }  else if type == .imageOnTop {
            buttons = getButtonsForNormalSegment(hasTopImage: true)
        } else if type == .imageOnly {
            buttons = getButtonsForOnlyImageSegment()
        }
        
        if selectedSegmentIndex < buttons.count {
            print("updateView: selectedSegmentIndex \(selectedSegmentIndex)")
            buttons[selectedSegmentIndex].tintColor = selectedTintColor(forButtonAtIndex: selectedSegmentIndex)
            buttons[selectedSegmentIndex].setTitleColor(selectedTextColor(forButtonAtIndex: selectedSegmentIndex),
                                                        for: .normal)
            buttons[selectedSegmentIndex].titleLabel?.font = selectedFont(forButtonAtIndex: selectedSegmentIndex)
        }
        
        setupUnderlineBar()
        
        addSubview(underlineBarView)
        
        let sv = UIStackView(arrangedSubviews: buttons)
        sv.axis = .horizontal
        sv.alignment = .fill
        sv.distribution = .fillEqually//.fillProportionally
        addSubview(sv)
        
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }


    private func setupUnderlineBar() {
        var selectorWidth = frame.width / CGFloat(buttonsCount())

        if type == .imageOnly {
            selectorWidth = frame.width / CGFloat(buttonsCount())
        }
        
        if selectorType == .normal {
            let underlineBarFrame = CGRect(x: 0,
                                           y: 0,
                                           width: selectorWidth,
                                           height: frame.height)
            underlineBarView = UIView(frame: underlineBarFrame)

            if isSegmentRounded == true {
                underlineBarView.layer.cornerRadius = frame.height / 2
            }
            else {
                underlineBarView.layer.cornerRadius = 0
            }
        }
        else if selectorType == .underlineBar {
            let underlineBarFrame = CGRect(x: 0,
                                           y: frame.height - bottomBarHeight,
                                           width: selectorWidth,
                                           height: bottomBarHeight)
            underlineBarView = UIView(frame: underlineBarFrame)

            if isUnderlineBarRounded == true {
                underlineBarView.layer.cornerRadius = underlineBarView.frame.height / 2
            }
            else {
                underlineBarView.layer.cornerRadius = 0
            }
        }
        // backgroundcolor will be set on moveUnderlineBar
        print("\(#function) - \(underlineBarView.frame)")
    }

    private func moveUnderlineBar(toIndex index: Int) {
        let newXOrigin = frame.width/CGFloat(buttons.count) * CGFloat(index)

        if animateUnderlineBarMovement == true {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            self.underlineBarView.frame.origin.x = newXOrigin },
                           completion: nil)
        }
        else {
            underlineBarView.frame.origin.x = newXOrigin
        }

        underlineBarView.backgroundColor = underlineBarColor(forButtonAtIndex: index)
    }

    private func getButtonsForNormalSegment(hasTopImage: Bool = false)
        -> [UIButton] {
            var newButtons = [UIButton]()

            for (index, buttonTitle) in mappedButtonTitles().enumerated() {
                let button = UIButton(type: .system)
                button.setTitle(buttonTitle, for: .normal)
                button.tag = index
                button.tintColor = unSelectedTintColor(forButtonAtIndex: index)
                button.setTitleColor(unSelectedTextColor(forButtonAtIndex: index),
                                     for: .normal)
                button.titleLabel?.font = selectedFont(forButtonAtIndex: index)
                button.titleLabel?.textAlignment = .center

                button.addTarget(self,
                                 action: #selector(buttonTapped(_:)),
                                 for: .touchUpInside)

                let buttonImagesNames = mappedButtonImageNames()
                if index < buttonImagesNames.count {
                    let imageName = buttonImagesNames[index]
                    if imageName.isEmpty == false {
                        let buttonImage = self.image(name: imageName)
                        button.setImage(buttonImage,
                                        for: .normal)

                        if hasTopImage == true {
                            button.centerImageAndButton(5, imageOnTop: true)
                        }
                        else {
                            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
                        }
                    }
                }

                newButtons.append(button)
            }
            
            return newButtons
    }


    private func getButtonsForOnlyImageSegment()
        -> [UIButton] {
            var newButtons = [UIButton]()

            for (index, buttonImageName) in mappedButtonImageNames().enumerated() {
                let button = UIButton(type: .system)
                let buttonImage = image(name: buttonImageName)
                button.setImage(buttonImage, for: .normal)
                button.tag = index
                button.tintColor = unSelectedTintColor
                button.addTarget(self,
                                 action: #selector(buttonTapped(_:)),
                                 for: .touchUpInside)

                newButtons.append(button)
            }

            return newButtons
    }

    private func image(name: String)
        -> UIImage {
            if let image = UIImage(named: name) {
                return image
            }

            if let systemImage = UIImage(systemName: name) {
                return systemImage
            }

            fatalError()
    }


    //MARK: - Action Methods
    @objc
    private func buttonTapped(_ sender: UIButton) {
        selectedSegmentIndex = sender.tag

        print("\(#function): selectedSegmentIndex: \(selectedSegmentIndex)")
        for (index, button) in buttons.enumerated() {
            button.tintColor = unSelectedTintColor(forButtonAtIndex: index)
            button.setTitleColor(unSelectedTextColor(forButtonAtIndex: index),
                                 for: .normal)
            button.titleLabel?.font = selectedFont(forButtonAtIndex: index)

            if button == sender {
                button.tintColor = selectedTintColor(forButtonAtIndex: index)
                button.setTitleColor(selectedTextColor(forButtonAtIndex: index),
                                     for: .normal)
                button.titleLabel?.font = unSelectedFont(forButtonAtIndex: index)

                moveUnderlineBar(toIndex: index)
            }
        }

        onValueChanged?(selectedSegmentIndex)
        sendActions(for: .valueChanged)
    }

}

//MARK: - Extension - SegmentDesciptor handling
extension SOXSegmentControl {
    private func segmentDescriptor(forIndex index: Int)
        -> SOXSegmentDescriptor? {
            guard let segmentDescriptors = self.segmentDescriptors,
                segmentDescriptors.count >= index
                else { return nil }

            let segmentDescriptor = segmentDescriptors[index]
            return segmentDescriptor
    }

    private func buttonsCount()
    -> Int {
        var buttonsCount = 0
        if let segmentDescriptors = self.segmentDescriptors {
            buttonsCount = segmentDescriptors.count
        }
        else {
            buttonsCount = buttonTitles.count
        }

        return buttonsCount
    }

    private func mappedButtonTitles()
        -> [String] {
            var buttonTitles: [String]
            if let segmentDescriptors = self.segmentDescriptors {
                buttonTitles = segmentDescriptors.map { (segmentDescriptor) -> String in
                    return segmentDescriptor.buttonTitle ?? ""
                }
            }
            else {
                buttonTitles = self.buttonTitles
            }

            return buttonTitles
    }

    private func mappedButtonImageNames()
        -> [String] {
            var buttonImageNames: [String]
            if let segmentDescriptors = self.segmentDescriptors {
                buttonImageNames = segmentDescriptors.map { (segmentDescriptor) -> String in
                    return segmentDescriptor.buttonImageName ?? ""
                }
            }
            else {
                buttonImageNames = self.buttonImageNames
            }

            return buttonImageNames
    }

//    private func buttonTitle(forButtonAtIndex index: Int)
//        -> String {
//            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
//                else {
//                    let buttonTitle = buttonTitles[index]
//                    return buttonTitle
//            }
//
//            let buttonTitle = segmentDescriptor.buttonTitle ?? ""
//            return buttonTitle
//    }
//
//    private func buttonImageName(forButtonAtIndex index: Int)
//        -> String {
//            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
//                else {
//                    let buttonImageName = buttonImageNames[index]
//                    return buttonImageName
//            }
//
//            let buttonImageName = segmentDescriptor.buttonImageName ?? ""
//            return buttonImageName
//    }


    private func selectedTextColor(forButtonAtIndex index: Int)
        -> UIColor {
            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
                else { return selectedTextColor }

            let selectedTextColor = segmentDescriptor.selectedTextColor
            return selectedTextColor
    }

    private func selectedTintColor(forButtonAtIndex index: Int)
        -> UIColor {
            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
                else { return selectedTintColor }

            let selectedTintColor = segmentDescriptor.selectedTintColor
            return selectedTintColor
    }

    private func unSelectedTextColor(forButtonAtIndex index: Int)
        -> UIColor {
            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
                else { return unSelectedTextColor }

            let unSelectedTextColor = segmentDescriptor.unSelectedTextColor
            return unSelectedTextColor
    }

    private func unSelectedTintColor(forButtonAtIndex index: Int)
        -> UIColor {
            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
                else { return unSelectedTintColor }

            let unSelectedTintColor = segmentDescriptor.unSelectedTintColor
            return unSelectedTintColor
    }

    private func underlineBarColor(forButtonAtIndex index: Int)
        -> UIColor {
            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
                else { return underlineBarColor }

            let underlineBarColor = segmentDescriptor.underlineBarColor
            return underlineBarColor
    }

    private func selectedFont(forButtonAtIndex index: Int)
        -> UIFont {
            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
                else { return selectedFont }

            let selectedFont = segmentDescriptor.selectedFont
            return selectedFont
    }

    private func unSelectedFont(forButtonAtIndex index: Int)
        -> UIFont {
            guard let segmentDescriptor = self.segmentDescriptor(forIndex: index)
                else { return unSelectedFont }

            let unSelectedFont = segmentDescriptor.unSelectedFont
            return unSelectedFont
    }
}

//MARK: - Extension - UIButton
extension UIButton {
    func centerImageAndButton(_ gap: CGFloat, imageOnTop: Bool) {
        
        guard let imageView = currentImage,
            let titleLabel = titleLabel?.text
            else { return }
        
        let sign: CGFloat = imageOnTop ? 1 : -1
        titleEdgeInsets = UIEdgeInsets(top: sign * (imageView.size.height + gap),
                                       left: -imageView.size.width,
                                       bottom: 0,
                                       right: 0);
        
        let titleSize = titleLabel.size(withAttributes:
            [NSAttributedString.Key.font: self.titleLabel!.font!])

        //TODO: get 'right' correct; 200420, ph
        imageEdgeInsets = UIEdgeInsets(top: sign * -(titleSize.height + gap),
                                       left: 0,
                                       bottom: 0,
                                       right: -titleSize.width - gap)
    }
    
}


