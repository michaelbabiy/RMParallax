// RMParallax
//
// Copyright (c) 2016 RMParallax
//
// Created by Raphael Miller & Michael Babiy
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit

class RMController : UIViewController {
    var dismiss: DismissCompletion?
    
    private let items: [RMItem]
    private var scrollView = UIScrollView()
    private var dismissButton = UIButton()
    
    fileprivate let style: Style
    fileprivate var currentPageNumber = 0
    fileprivate var otherPageNumber = 0
    fileprivate var lastContentOffset: CGFloat = 0.0
    
    enum Style {
        case motion
        case subtle
    }
    
    /*
        Designated initializer.
     
        @param items  - an array of items to page through.
        @param style - style to apply when paging.
     */
    
    required init(with items: [RMItem], style: Style = .subtle) {
        self.items = items
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init with items, motion.")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupDismissButton()
        setupItems()
    }
    
    // MARK: Setup
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func setupDismissButton() {
        view.insertSubview(dismissButton, aboveSubview: scrollView)
        dismissButton.setImage(UIImage(named: "close_button"), for: .normal)
        dismissButton.addTarget(self, action: #selector(closeButtonSelected(_:)), for: .touchUpInside)
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.widthAnchor.constraint(equalToConstant: 23.0).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 23.0).isActive = true
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10.0).isActive = true
    }
    
    private func setupItems() {
        for (index, item) in items.enumerated() {
            let containerFrame = CGRect(x: (view.frame.width * CGFloat(index)), y: 0.0, width: view.frame.width, height: view.frame.height)
            let container = UIView(frame: containerFrame)
            let internalScrollView = makeScrollView(withTag: (index + 1) * 10)
            let internalTextScrollView = makeScrollView(withTag: (index + 1) * 100)
            let imageView = makeImageView(with: CGSize(width: internalScrollView.frame.width + style.motionFrameOffset, height: view.frame.height + style.motionFrameOffset), image: item.image)
            let textLabel = makeLabel(with: item.text)

            internalTextScrollView.addSubview(textLabel)
            internalScrollView.addSubview(imageView)
            internalScrollView.addSubview(internalTextScrollView)
            container.addSubview(internalScrollView)
            
            scrollView.addSubview(container)
            addMotionEffect(to: imageView)
        }
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(items.count), height: view.frame.height)
    }
    
    // MARK: Factory & Constraints
    
    private func makeImageView(with size: CGSize, image: UIImage) -> UIImageView {
        let imageViewFrame = CGRect(origin: .zero, size: size)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        return imageView
    }
    
    private func makeLabel(with text: String) -> UILabel {
        let attributes = [NSFontAttributeName : style.font]
        let context = NSStringDrawingContext()
        let rect = text.boundingRect(with: CGSize(width: style.textSpan, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: context)
        let labelFrame = CGRect(x: 10.0, y: view.frame.height / 2.0, width: style.textSpan, height: rect.size.height)
        let label = UILabel(frame: labelFrame)
        label.numberOfLines = 0
        label.text = text
        label.textColor = style.textColor
        label.font = style.font
        return label
    }
    
    private func makeScrollView(withTag tag: Int) -> UIScrollView {
        let internalScrollView = UIScrollView(frame: CGRect(x: 0.0, y: 0.0, width: view.frame.width, height: view.frame.height))
        internalScrollView.isScrollEnabled = false
        internalScrollView.tag = tag
        return internalScrollView
    }
    
    // MARK: Motion
    
    private func addMotionEffect(to view: UIView) -> Void {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        xMotion.minimumRelativeValue = (-style.motionMagnitude)
        xMotion.maximumRelativeValue = (style.motionMagnitude)
        yMotion.minimumRelativeValue = (-style.motionMagnitude)
        yMotion.maximumRelativeValue = (style.motionMagnitude)
        let motionGroup = UIMotionEffectGroup()
        motionGroup.motionEffects = [xMotion, yMotion]
        view.addMotionEffect(motionGroup)
    }
    
    // MARK: Action
    
    @objc private func closeButtonSelected(_ sender: UIButton) {
        dismiss?()
    }
    
    typealias DismissCompletion = () -> Void
}

extension RMController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let internalScrollView = scrollView.viewWithTag((currentPageNumber + 1) * 10) as? UIScrollView {
            internalScrollView.contentOffset = .zero
        }
        
        if let otherScrollView = scrollView.viewWithTag((otherPageNumber + 1) * 10) as? UIScrollView {
            otherScrollView.contentOffset = .zero
        }
        
        if let internalTextScrollView = scrollView.viewWithTag((currentPageNumber + 1) * 100) as? UIScrollView {
            internalTextScrollView.contentOffset = .zero
        }
        
        if let otherTextScrollView = scrollView.viewWithTag((otherPageNumber + 1) * 100) as? UIScrollView {
            otherTextScrollView.contentOffset = .zero
        }
        currentPageNumber = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var multiplier: CGFloat = 1.0
        let offset: CGFloat = scrollView.contentOffset.x
        if lastContentOffset > scrollView.contentOffset.x {
            if currentPageNumber > 0 {
                if offset >  CGFloat(currentPageNumber - 1) * view.frame.width {
                    otherPageNumber = currentPageNumber + 1
                    multiplier = 1.0
                } else {
                    otherPageNumber = currentPageNumber - 1
                    multiplier = -1.0
                }
            }
        } else if lastContentOffset < scrollView.contentOffset.x {
            if offset <  CGFloat(currentPageNumber - 1) * view.frame.width {
                otherPageNumber = currentPageNumber - 1
                multiplier = -1.0
            } else {
                otherPageNumber = currentPageNumber + 1
                multiplier = 1.0
            }
        }
        lastContentOffset = scrollView.contentOffset.x
        if let internalScrollView = scrollView.viewWithTag((currentPageNumber + 1) * 10) as? UIScrollView {
            internalScrollView.contentOffset = CGPoint(x: -style.viewOffsetMultiplier * (offset - (view.frame.width * CGFloat(currentPageNumber))), y: 0.0)
        }
        
        if let otherScrollView = scrollView.viewWithTag((otherPageNumber + 1) * 10) as? UIScrollView {
            let x: CGFloat = multiplier * style.viewOffsetMultiplier * view.frame.width - (style.viewOffsetMultiplier * (offset - (view.frame.width * CGFloat(currentPageNumber))))
            otherScrollView.contentOffset = CGPoint(x: x, y: 0.0)
        }
        
        if let internalTextScrollView = scrollView.viewWithTag((currentPageNumber + 1) * 100) as? UIScrollView {
            internalTextScrollView.contentOffset = CGPoint(x: -style.textOffsetMultiplier * (offset - (view.frame.width * CGFloat(currentPageNumber))), y: 0.0)
        }
        
        if let otherTextScrollView = scrollView.viewWithTag((otherPageNumber + 1) * 100) as? UIScrollView {
            let x: CGFloat = multiplier * style.textOffsetMultiplier * view.frame.width - (style.textOffsetMultiplier * (offset - (view.frame.width * CGFloat(currentPageNumber))))
            otherTextScrollView.contentOffset = CGPoint(x: x, y: 0.0)
        }
    }
}
