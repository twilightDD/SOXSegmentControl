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
public struct SOXSegmentDescriptor: Equatable {
    public var buttonTitle: String?
    public var buttonImageName: String?

    public var selectedTextColor: UIColor = .label
    public var selectedTintColor: UIColor = .label
    public var unSelectedTextColor: UIColor = .lightGray
    public var unSelectedTintColor: UIColor = .lightGray
    public var selectorColor: UIColor = .lightGray

    public var selectedFont : UIFont = UIFont.systemFont(ofSize: 15)
    public var unSelectedFont : UIFont = UIFont.systemFont(ofSize: 15)

    // In case of doublets we need a distinctive marker; 220420, ph
    private let uuid = UUID()

    public static func == (lhs: SOXSegmentDescriptor, rhs: SOXSegmentDescriptor)
        -> Bool {
            return lhs.uuid == rhs.uuid
    }
//}
//
////MARK: SOXSegmentDescriptor - Convenient Init
//extension SOXSegmentDescriptor {

    public init(buttonTitle: String? = nil,
                buttonImageName: String? = nil,
                selectedColor: UIColor? = .label,
                unSelectedColor: UIColor? = .lightGray) {

        self.buttonTitle = buttonTitle
        self.buttonImageName = buttonImageName

        self.selectedTextColor = selectedColor ?? .label
        self.selectedTintColor = selectedColor ?? .label
        self.selectorColor = selectedColor ?? .lightGray

        self.unSelectedTextColor = unSelectedColor ?? .lightGray
        self.unSelectedTintColor = unSelectedColor ?? .lightGray

    }
}

//MARK: -
//MARK: - SOXSegmentControl
open class SOXSegmentControl: UIControl {

    //MARK: Enums
    public enum SegmentType: Int {
        case normal
        case imageOnTop
        case imageOnly
    }

    public enum SelectorType: Int {
        case none
        case background
        case underlineBar
    }

    public enum SelectorStyle: Int {
        case square
        case round
        case rounded // set selectorCornerRadius
    }

    //MARK: - Lets and Vars
    //MARK: Selector Background Properties
    private var selectorView: UIView? {
        get {
            if _selectorView != nil {
                return _selectorView
            }
            else {
                if selectorType == .none {
                    return nil
                }
                else {
                    // _selectorView = UIView()
                    setupSelectorView()
                    return _selectorView
                }
            }
        }
        set {
            _selectorView = newValue
        }
    }
    private var _selectorView: UIView?
    public var animateSelectorMovement: Bool = true
    public var selectorColor: UIColor = .darkGray { didSet { updateSelectorViewBackgroundColor() } }
    public var selectorStyle: SelectorStyle = .square { didSet { updateSelectorViewStyle()} }
    public var selectorType: SOXSegmentControl.SelectorType = .background { didSet { updateSelectorViewHeight() } }

    public var selectorCornerRadius: CGFloat = 5.0 { didSet { updateSelectorViewStyle() } }
    public var underlineBarSelectorHeight : CGFloat = 5.0  { didSet { updateSelectorViewHeight() } }

    //MARK:

    var onValueChanged: ((_ index: Int)->())?
    public var selectedSegmentIndex: Int = 0  {
        didSet {
            print("\(#function) selectedSegmentIndex didSet to \(selectedSegmentIndex)")
        } }

    public var type: SOXSegmentControl.SegmentType = .normal { didSet { updateView() } }


    var buttonTitles = [String]() { didSet { updateView() } }
    var buttonImageNames = [String]() { didSet { updateView() } }
    public var segmentDescriptors: [[SOXSegmentDescriptor]]? {
        didSet {
            updateSegments()
            updateView()

        } }
    private var linearSegmentDescriptors: [SOXSegmentDescriptor]?



    // UI


    var borderWidth: CGFloat = 0 { didSet { layer.borderWidth = borderWidth } }
    var borderColor: UIColor = .clear { didSet { layer.borderColor = borderColor.cgColor } }
    var cornerRadius: CGFloat = 0 { didSet { layer.cornerRadius = cornerRadius } }

    var selectedTextColor: UIColor = .label { didSet { updateView() } }
    var selectedTintColor: UIColor = .label { didSet { updateView() } }
    var unSelectedTextColor: UIColor = .lightGray { didSet { updateView() } }
    var unSelectedTintColor: UIColor = .lightGray { didSet { updateView() } }


    var selectedFont : UIFont = UIFont.systemFont(ofSize: 15) { didSet { updateView() } }
    var unSelectedFont : UIFont = UIFont.systemFont(ofSize: 15) { didSet { updateView() } }



    //MARK: - Private Properties
    private var segmentDescriptorsOfRows = [Int : [SOXSegmentDescriptor]]()

    private var segments = [UIButton]()
    private var segmentToRow = [UIButton : Int]()
    private var segmentCount: Int = 0


    //MARK: - Open Methods
    open override func layoutSubviews() {
        super.layoutSubviews()

        updateView()

        //        let _animated = animateSelectorMovement
        //        animateSelectorMovement = false
        //        setSelectedIndex(selectedSegmentIndex)
        //        animateSelectorMovement = _animated
    }



    open func setSelectedIndex(_ index: Int) {
        selectedSegmentIndex = index

        for (index, button) in segments.enumerated() {
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
                moveSelectorView(toIndex: index)
            }
        }
    }

    open func changeSelectedColor(_ color: UIColor) {
        guard let underlineBarView = self.selectorView
            else { return }

        underlineBarView.backgroundColor = color
    }

    //MARK: - Private Methods
    private func updateSegments() {
        guard let segmentDescriptors = self.segmentDescriptors
            else { return }

        var gatheredSegmentDescriptors = [SOXSegmentDescriptor]()
        for (row, segmentDescriptorsForRow) in segmentDescriptors.enumerated() {
            segmentDescriptorsOfRows.updateValue(segmentDescriptorsForRow, forKey: row)
            gatheredSegmentDescriptors.append(contentsOf: segmentDescriptorsForRow)

        }

        linearSegmentDescriptors = gatheredSegmentDescriptors
    }

    private func updateView() {
        clipsToBounds = true
        segments.removeAll()
        subviews.forEach( { $0.removeFromSuperview() } )

        if type == .normal {
            segments = getButtonsForNormalSegment(hasTopImage: false)
        }  else if type == .imageOnTop {
            segments = getButtonsForNormalSegment(hasTopImage: true)
        } else if type == .imageOnly {
            segments = getButtonsForOnlyImageSegment()
        }

        if selectedSegmentIndex < segments.count {
            print("updateView: selectedSegmentIndex \(selectedSegmentIndex)")
            segments[selectedSegmentIndex].tintColor = selectedTintColor(forButtonAtIndex: selectedSegmentIndex)
            segments[selectedSegmentIndex].setTitleColor(selectedTextColor(forButtonAtIndex: selectedSegmentIndex),
                                                         for: .normal)
            segments[selectedSegmentIndex].titleLabel?.font = selectedFont(forButtonAtIndex: selectedSegmentIndex)
        }

        if let underlineBarView = self.selectorView {
            addSubview(underlineBarView)
        }

        arrangeSegments()
    }

    private func arrangeSegments() {
        guard let segmentDescriptors = self.segmentDescriptors
            else { return}

        // Outer StackView
        let outerStackView = UIStackView()
        outerStackView.axis = .vertical
        outerStackView.alignment = .fill
        outerStackView.distribution = .fillEqually

        addSubview(outerStackView)
        outerStackView.translatesAutoresizingMaskIntoConstraints = false
        outerStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outerStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        outerStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        outerStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

        var startCount = 0
        for segmentDescriptorsForRow in segmentDescriptors {
            let columnsCount = segmentDescriptorsForRow.count
            let endCount = startCount + columnsCount - 1
            let slice = segments[startCount...endCount]
            startCount = startCount + columnsCount // without - 1!

            let segmentsOfRow:[UIView] = Array(slice)

            let rowStackView = UIStackView(arrangedSubviews: segmentsOfRow)
            rowStackView.axis = .horizontal
            rowStackView.alignment = .fill
            rowStackView.distribution = .fillEqually//.fillProportionally

            outerStackView.addArrangedSubview(rowStackView)
            //outerStackView.updateConstraints()
            //outerStackView.setNeedsLayout()
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
        }
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
}

//MARK: - Extension - Background Selector View
extension SOXSegmentControl {
    //    private func updateSelectorView() {
    //        if selectorType == .none {
    //            selectorView = nil
    //            return
    //        }
    //
    //        let selectorWidth = frame.width / CGFloat(buttonsCount())
    //
    //        var underlineBarFrame: CGRect?
    //        if selectorType == .background {
    //            underlineBarFrame = CGRect(x: 0,
    //                                           y: 0,
    //                                           width: selectorWidth,
    //                                           height: frame.height)
    //
    //        }
    //        else if selectorType == .underlineBar {
    //             underlineBarFrame = CGRect(x: 0,
    //                                           y: frame.height - bottomBarHeight,
    //                                           width: selectorWidth,
    //                                           height: bottomBarHeight)
    //        }
    //        else {
    //            fatalError("Selectortype \(selectorType) unknown.")
    //        }
    //
    //        if selectorView == nil {
    //            selectorView = UIView(frame: underlineBarFrame!)
    //        }
    //        else {
    //            selectorView?.frame = underlineBarFrame!
    //        }
    //
    //        if isSelectorViewRounded == true {
    //            selectorView!.layer.cornerRadius = frame.height / 2
    //        }
    //        else {
    //            selectorView!.layer.cornerRadius = 0
    //        }
    //    }

    private func setupSelectorView() {
        _selectorView = UIView()

        updateSelectorViewBackgroundColor()
        updateSelectorViewFrame()
    }


    private func updateSelectorViewBackgroundColor() {
        selectorView?.backgroundColor = backgroundColor
    }

    private func updateSelectorViewFrame() {

    }

    private func updateSelectorViewHeight() {
        guard let selectorView = self.selectorView,
            let segmentDescriptors = self.segmentDescriptors
            else { return }

        if selectorType == .background {
            let newHeight = (frame.height) / CGFloat(segmentDescriptors.count)
            selectorView.frame.size.height = newHeight
        }
        else if selectorType == .underlineBar {

            moveSelectorView(toIndex: selectedSegmentIndex)
        }

        updateSelectorViewStyle()
    }

    private func updateSelectorViewStyle() {
        guard let selectorView = self.selectorView
            else { return }

        var cornerRadius: CGFloat
        switch selectorStyle {
            case .round:
                cornerRadius = selectorView.frame.height / 2
            case .rounded:
                cornerRadius = selectorCornerRadius
            default:
                cornerRadius = 0
        }

        selectorView.layer.cornerRadius = cornerRadius
    }


    private func moveSelectorView(toIndex index: Int) {
        guard let selectorView = self.selectorView
            else { return }

        let buttonForIndex = segments[index]
        guard let buttonOrigin = buttonForIndex.superview?.convert(buttonForIndex.frame.origin,
                                                                   to: buttonForIndex.superview?.superview)
            else { return }

        let newOriginX = buttonOrigin.x
        var newOriginY = buttonOrigin.y
        let newWidth = buttonForIndex.frame.width
        var newHeight = buttonForIndex.frame.height

        if selectorType == .underlineBar {
            newOriginY = newOriginY + buttonForIndex.frame.height - selectorView.frame.height
            newHeight = underlineBarSelectorHeight
        }

        let newUnderlineBarFrame = CGRect(x: newOriginX,
                                          y: newOriginY,
                                          width: newWidth,
                                          height: newHeight)

        if animateSelectorMovement == true {
            UIView.animate(withDuration: 0.25,
                           delay: 0,
                           options: .curveEaseOut,
                           animations: {
                            self.selectorView!.frame = newUnderlineBarFrame

            },
                           completion: nil)
        }
        else {
            selectorView.frame = newUnderlineBarFrame

        }

        selectorView.backgroundColor = underlineBarColor(forButtonAtIndex: index)
    }

}


//MARK: - Extension - Action Methods
extension SOXSegmentControl {

    @objc
    private func buttonTapped(_ sender: UIButton) {
        selectedSegmentIndex = sender.tag

        print("\(#function): selectedSegmentIndex: \(selectedSegmentIndex)")
        for (index, button) in segments.enumerated() {
            button.tintColor = unSelectedTintColor(forButtonAtIndex: index)
            button.setTitleColor(unSelectedTextColor(forButtonAtIndex: index),
                                 for: .normal)
            button.titleLabel?.font = selectedFont(forButtonAtIndex: index)

            if button == sender {
                button.tintColor = selectedTintColor(forButtonAtIndex: index)
                button.setTitleColor(selectedTextColor(forButtonAtIndex: index),
                                     for: .normal)
                button.titleLabel?.font = unSelectedFont(forButtonAtIndex: index)

                moveSelectorView(toIndex: index)
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
            guard let segmentDescriptors = self.linearSegmentDescriptors,
                segmentDescriptors.count >= index
                else { return nil }
            let segmentDescriptor = segmentDescriptors[index]
            return segmentDescriptor
    }

    private func rowForSegmentDescriptor(_ segmentDescriptor: SOXSegmentDescriptor)
        -> Int {
            for (row, segmentDescriptorsOfRow) in segmentDescriptorsOfRows {
                let titles = segmentDescriptorsOfRow.map { (segmentDesc) -> String in
                    segmentDesc.buttonTitle!
                }
                print("segmentDescriptorsOfRow:\n \(titles)")
                if segmentDescriptorsOfRow.contains(segmentDescriptor) {
                    print("\(#function) \(row): count \(segmentDescriptorsOfRow.count)")
                    return row
                }
            }
            fatalError()
    }


    private func mappedButtonTitles()
        -> [String] {
            var buttonTitles: [String]
            if let segmentDescriptors = self.linearSegmentDescriptors {
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
            if let segmentDescriptors = self.linearSegmentDescriptors {
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
                else { return selectorColor }

            let underlineBarColor = segmentDescriptor.selectorColor
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


