//
//  ViewController.swift
//  Example
//
//  Created by zevwings on 2017/7/11.
//  Copyright © 2017-2019 zevwings. All rights reserved.
//

import UIKit
import ZVProgressHUD

class ViewController: UIViewController {

    var rows = [
        ("show", #selector(showIndicator)),
        ("showWithLabel", #selector(showWithLabel)),
        ("showProgress", #selector(showProgress)),
        ("showProgressWithLabel", #selector(showProgressWithLabel)),
        ("showError", #selector(showError)),
        ("showSuccess", #selector(showSuccess)),
        ("showWarning", #selector(showWarning)),
        ("showCustomImage", #selector(showCustomImage)),
        ("showCustomImageWithLabel", #selector(showCustomImageWithLabel)),
        ("showAnimation", #selector(showCustomView)),
        ("showLabel", #selector(showLabel)),
        ("dismiss", #selector(dismissHUD))
    ]

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var showDelayTimeTextField: UITextField!
    @IBOutlet weak var dismissDelayTimeTextField: UITextField!

    var progress: Float = 0.0
    var timer: Timer?
    var useInstanceMethod: Bool = false
    var hud: ProgressHUD?
    
    @IBOutlet weak var indicatorSizeLabel: UILabel!
    var indicatorSize: CGSize = CGSize(width: 48.0, height: 48.0)
    @IBOutlet weak var logoSizeLabel: UILabel!
    var logoSize: CGSize = CGSize(width: 30.0, height: 30.0)

    var displayStyle: DisplayStyle = .dark
    var maskType: MaskType = .black
    var animationType: AnimationType = .flat

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        ProgressHUD.shared.indicatorSize
        ProgressHUD.shared.maskType = .black
        ProgressHUD.shared.displayStyle = .dark
        ProgressHUD.shared.logoSize = logoSize
        ProgressHUD.shared.logo = UIImage(named: "logo_crown")?.withRenderingMode(.alwaysTemplate)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(progressHUDTouchEvent(_:)),
                                               name: .ProgressHUDReceivedTouchUpInsideEvent,
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

// MARK: - ProgressHUD Notification

extension ViewController {

    @objc func progressHUDTouchEvent(_ notification: Notification) {
        timer?.invalidate()
        timer = nil
        self.dismissHUD()
    }
}

// MARK: - ProgressHUD

extension ViewController {

    @objc func showIndicator() {
        
        let showDelay = getShowDelayTime()
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.show(delay: showDelay)
        } else {
            ProgressHUD.shared.show(delay: showDelay)
        }
    }

    @objc func showWithLabel() {
        
        let showDelay = getShowDelayTime()
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.show(with: "loading", delay: showDelay)
        } else {
            ProgressHUD.shared.show(with: "loading", delay: showDelay)
        }
    }

    @objc func showError() {
        
        let showDelay = getShowDelayTime()
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showError(with: "error", delay: showDelay)
        } else {
            ProgressHUD.shared.showError(with: "error", delay: showDelay)
        }
    }

    @objc func showSuccess() {
        
        let showDelay = getShowDelayTime()
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showSuccess(with: "success", delay: showDelay)
        } else {
            ProgressHUD.shared.showSuccess(with: "success", delay: showDelay)
        }
    }

    @objc func showWarning() {
        
        let showDelay = getShowDelayTime()
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showWarning(with: "warning", delay: showDelay)
        } else {
            ProgressHUD.shared.showWarning(with: "warning", delay: showDelay)
        }
    }

    @objc func showCustomImage() {
        
        let showDelay = getShowDelayTime()
        let image = UIImage(named: "smile")

        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showImage(image!, delay: showDelay)
        } else {
            ProgressHUD.shared.showImage(image!, delay: showDelay)
        }
    }

    @objc func showCustomImageWithLabel() {
        
        let showDelay = getShowDelayTime()
        let image = UIImage(named: "smile")

        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showImage(image!, title: "smile everyday", delay: showDelay)
        } else {
            ProgressHUD.shared.showImage(image!, title: "smile everyday", delay: showDelay)
        }
    }

    @objc func showProgress() {
        
        self.progress = 0
        if  self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showProgress(0.0)
        } else {
            ProgressHUD.shared.showProgress(0.0)
        }
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.25,
            target: self,
            selector: #selector(ViewController.progressTimerAction(_:)),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func showProgressWithLabel() {
        
        let showDelay = getShowDelayTime()
        self.progress = 0
        if  self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showProgress(0.0, title: "Progress", delay: showDelay)
        } else {
            ProgressHUD.shared.showProgress(0.0, title: "Progress", delay: showDelay)
        }
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.25,
            target: self,
            selector: #selector(ViewController.progressTimerAction(_:)),
            userInfo: ["title": "Progress"],
            repeats: true
        )
    }


    @objc func showCustomView() {

        let showDelay = getShowDelayTime()
        var images = [UIImage]()
        for index in 1 ... 3 {
            let image = UIImage(named: "loading_0\(index)")
            images.append(image!)
        }
        
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showAnimation(images, delay: showDelay)
        } else {
            ProgressHUD.shared.showAnimation(images, delay: showDelay)
        }
    }

    @objc func showLabel() {
        
        let showDelay = getShowDelayTime()
        if (useInstanceMethod) {
            if hud == nil { hud = ProgressHUD() }
            hud?.indicatorSize = indicatorSize
            hud?.displayStyle = displayStyle
            hud?.maskType = maskType
            hud?.animationType = animationType
            hud?.showText("pure text", in: self.view, delay: showDelay)
        } else {
            ProgressHUD.shared.showText("pure text", in: self.view, delay: showDelay)
        }
    }

    @objc func dismissHUD() {

        let dismissDelay = getDismissDelayTime()
        if (useInstanceMethod) {
            hud?.dismiss(with: dismissDelay, completion: {
                print("dimiss delay 2 second.")
            })
        } else {
            ProgressHUD.shared.dismiss(with: dismissDelay) {
                print("dimiss")
            }
        }
    }

    func getShowDelayTime() -> TimeInterval {
        return TimeInterval(self.showDelayTimeTextField.text ?? "") ?? 0
    }
    
    func getDismissDelayTime() -> TimeInterval {
        return TimeInterval(self.dismissDelayTimeTextField.text ?? "") ?? 0
    }
    
    @IBAction func setIndicatorViewSize(_ sender: UISlider) {
        let size = CGFloat(sender.value)
        indicatorSize = CGSize(width: size, height: size)
        ProgressHUD.shared.indicatorSize = indicatorSize
        indicatorSizeLabel.text = "Indicator Size (\(String(format: "%.2f", size)))"

    }
    
    @IBAction func setLogoViewSize(_ sender: UISlider) {
        let size = CGFloat(sender.value)
        logoSize = CGSize(width: size, height: size)
        ProgressHUD.shared.logoSize = logoSize
        
        logoSizeLabel.text = "Logo Size (\(String(format: "%.2f", size)))"

    }
    
    @IBAction func setDisplayStyle(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            ProgressHUD.shared.displayStyle = .dark
            displayStyle = .dark
            break
        case 1:
            ProgressHUD.shared.displayStyle = .light
            displayStyle = .light
            break
        case 2:
            let backgroundColor = UIColor(red: 86.0 / 255.0, green: 75.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
            let foregroundColor = UIColor(red: 239.0 / 255.0, green: 83.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
            ProgressHUD.shared.displayStyle = .custom(backgroundColor: backgroundColor,
                                                 foregroundColor: foregroundColor)
            
            displayStyle = .custom(backgroundColor: backgroundColor,
                                   foregroundColor: foregroundColor)
            break
        default:
            break
        }
    }

    @IBAction func setMaskType(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            ProgressHUD.shared.maskType = .clear
            maskType = .clear
            break
        case 1:
            ProgressHUD.shared.maskType = .none
            maskType = .none
            break
        case 2:
            ProgressHUD.shared.maskType = .black
            maskType = .black
            break
        case 3:
            let color = UIColor(red: 215.0 / 255.0, green: 22.0 / 255.0, blue: 59.0 / 255.0, alpha: 0.35)
            ProgressHUD.shared.maskType = .custom(color: color)
            maskType = .custom(color: color)
        default:
            break
        }
    }

    @IBAction func setAnimationType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            ProgressHUD.shared.animationType = .flat
            animationType = .flat
            break
        case 1:
            ProgressHUD.shared.animationType = .native
            animationType = .native
            break
        default:
            break
        }
    }
    
    @IBAction func setMethodMode(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            useInstanceMethod = false
            break
        case 1:
            useInstanceMethod = true
            break
        default:
            break
        }
    }

    @objc func progressTimerAction(_ sender: Timer?) {

        let userInfo = sender?.userInfo as? [String: String]
        let title = userInfo?["title"] ?? ""
        progress += 0.05
        if (useInstanceMethod) {
            hud?.showProgress(progress, title: title)
        } else {
            ProgressHUD.shared.showProgress(progress, title: title)
        }

        print("timer action : \(progress)")
        
        if progress > 1.0 {
            timer?.invalidate()
            timer = nil
        }
    }
}

extension ViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseIdentifier")
        cell?.textLabel?.text = self.rows[indexPath.row].0
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
        cell?.textLabel?.textColor = UIColor(white: 0.2, alpha: 1.0)
        return cell!
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selector = self.rows[indexPath.row].1
        self.perform(selector)
    }
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()

        return true
    }
}

extension ViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
}

