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
        ("showAnimation", #selector(showAnimation)),
        ("showCustomView", #selector(showCustomView)),
        ("showLabel", #selector(showLabel)),
        ("dismiss", #selector(dismissHUD))
    ]

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var delayShowTimeLabel: UIView!
    @IBOutlet weak var delayDismissTimeLabel: UIView!

    var showDelay: TimeInterval = 0
    var dismissDelay: TimeInterval = 0
    
    var progress: Float = 0.0
    var timer: Timer?
    
    var countDown: Int = 0
    private lazy var loadingView: ZVDownloadingView = {
        let loadingView = ZVDownloadingView() 
        return loadingView
    }()
    
    @IBOutlet weak var indicatorSizeLabel: UILabel!
    @IBOutlet weak var logoSizeLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ZVProgressHUD.setMaskType(.black)
        ZVProgressHUD.setDisplayStyle(.dark)
        ZVProgressHUD.setLogoSize(CGSize(width: 30.0, height: 30.0))
        
//        ZVProgressHUD.setProgressLabelColor(.green)
//        ZVProgressHUD.setTitleLabelColor(.cyan)

        let logo = UIImage(named: "logo_crown")?.withRenderingMode(.alwaysTemplate)
        ZVProgressHUD.setLogo(logo)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(ZVProgressHUDTouchEvent(_:)),
                                               name: .ZVProgressHUDReceivedTouchUpInsideEvent,
                                               object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}

// MARK: - ZVProgressHUD Notification

extension ViewController {

    @objc func ZVProgressHUDTouchEvent(_ notification: Notification) {
        timer?.invalidate()
        timer = nil
        self.dismissHUD()
    }
}

// MARK: - ZVProgressHUD

extension ViewController {

    @objc func showIndicator() {
        
        ZVProgressHUD.show(delay: showDelay)
    }

    @objc func showWithLabel() {
        
        ZVProgressHUD.show(with: "loading", delay: showDelay)
    }

    @objc func showError() {
        
        ZVProgressHUD.showError(with: "error", delay: showDelay)
    }

    @objc func showSuccess() {
        
        ZVProgressHUD.showSuccess(with: "success", delay: showDelay)
    }

    @objc func showWarning() {
        
        ZVProgressHUD.showWarning(with: "warning", delay: showDelay)
    }

    @objc func showCustomImage() {
        
        let image = UIImage(named: "smile")
        ZVProgressHUD.showImage(image!, delay: showDelay)
    }

    @objc func showCustomImageWithLabel() {
        
        let image = UIImage(named: "smile")
        ZVProgressHUD.showImage(image!, title: "smile everyday", delay: showDelay)
    }

    @objc func showProgress() {
        
        self.progress = 0
        if  self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        ZVProgressHUD.showProgress(0.0)
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.25,
            target: self,
            selector: #selector(ViewController.progressTimerAction(_:)),
            userInfo: nil,
            repeats: true
        )
    }

    @objc func showProgressWithLabel() {
        
        self.progress = 0
        if  self.timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        ZVProgressHUD.showProgress(0.0, title: "Progress", delay: showDelay)

        self.timer = Timer.scheduledTimer(
            timeInterval: 0.25,
            target: self,
            selector: #selector(ViewController.progressTimerAction(_:)),
            userInfo: ["title": "Progress"],
            repeats: true
        )
    }

    @objc func showAnimation() {

        var images = [UIImage]()
        for index in 1 ... 3 {
            let image = UIImage(named: "loading_0\(index)")
            images.append(image!)
        }
        
        ZVProgressHUD.showAnimation(images, delay: showDelay)

    }
    
    @objc func showCustomView() {
        
        var configuration = ZVProgressHUD.Configuration()
        configuration.animationType = .native
        configuration.displayStyle = .custom((.clear, .clear))
        configuration.maskType = .black

        loadingView.show(with: "Request Data ....")
        ZVProgressHUD.showCustomView(loadingView, with: configuration)

        countDown = 0
        progress = 0
        
        self.timer = Timer.scheduledTimer(
            timeInterval: 0.25,
            target: self,
            selector: #selector(ViewController.customProgressTimerAction(_:)),
            userInfo: ["title": "Progress"],
            repeats: true
        )

    }
    
    @objc func showLabel() {
        
        ZVProgressHUD.showText("pure text", in: self.view, delay: showDelay)

    }

    @objc func dismissHUD() {

        ZVProgressHUD.dismiss(delay: dismissDelay) {
            print("dimiss")
        }
    }

    
    @IBAction func setDisplayStyle(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            ZVProgressHUD.setDisplayStyle(.dark)
        case 1:
            ZVProgressHUD.setDisplayStyle(.light)
        case 2:
            let backgroundColor = UIColor(red: 86.0 / 255.0, green: 75.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
            let foregroundColor = UIColor(red: 239.0 / 255.0, green: 83.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
            ZVProgressHUD.setDisplayStyle(.custom((backgroundColor, foregroundColor)))
        default:
            break
        }
    }

    @IBAction func setMaskType(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            ZVProgressHUD.setMaskType(.clear)
        case 1:
            ZVProgressHUD.setMaskType(.none)
        case 2:
            ZVProgressHUD.setMaskType(.black)
        case 3:
            let color = UIColor(red: 215.0 / 255.0, green: 22.0 / 255.0, blue: 59.0 / 255.0, alpha: 0.35)
            ZVProgressHUD.setMaskType(.custom(color: color))
        default:
            break
        }
    }

    @IBAction func setAnimationType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            ZVProgressHUD.setAnimationType(.flat)
        case 1:
            ZVProgressHUD.setAnimationType(.native)
        default:
            break
        }
    }
    
    @IBAction func setIndicatorViewSize(_ sender: UISlider) {
        let size = CGFloat(sender.value)
        ZVProgressHUD.setIndicatorSize(CGSize(width: size, height: size))
        indicatorSizeLabel.text = "Indicator Size (\(String(format: "%.2f", size)))"

    }
    
    @IBAction func setLogoViewSize(_ sender: UISlider) {
        let size = CGFloat(sender.value)
        
        ZVProgressHUD.setLogoSize(CGSize(width: size, height: size))
        logoSizeLabel.text = "Logo Size (\(String(format: "%.2f", size)))"
    }
        
    @IBAction func setDelayShow(_ sender: UISlider) {
        self.showDelay = TimeInterval(sender.value)
    }
    
    @IBAction func setDelayDismiss(_ sender: UISlider) {
        self.dismissDelay = TimeInterval(sender.value)
    }

    @objc func progressTimerAction(_ sender: Timer?) {

        let userInfo = sender?.userInfo as? [String: String]
        let title = userInfo?["title"] ?? ""
        progress += 0.05
        ZVProgressHUD.showProgress(progress, title: title)

        print("timer action : \(progress)")
        
        if progress > 1.0 {
            timer?.invalidate()
            timer = nil
        }
    }
    
    @objc func customProgressTimerAction(_ sender: Timer?) {

        let userInfo = sender?.userInfo as? [String: String]
        let title = userInfo?["title"] ?? ""
//        progress += 0.05
        
        countDown += 1
        
        guard countDown >= 10 else { return }
        
        if countDown == 10 {
            loadingView.start()
        }
        
        progress += 0.05
        
        loadingView.update(progress)

        print("timer action : \(progress)")
        
        if progress > 1.0 {
            timer?.invalidate()
            timer = nil
            
            loadingView.dismiss()
            ZVProgressHUD.dismiss()
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

