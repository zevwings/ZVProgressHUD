//
//  ViewController.swift
//  ZVActivityIndicatorViewExample
//
//  Created by 张伟 on 09/02/2018.
//  Copyright © 2018 zevwings. All rights reserved.
//

import UIKit
import ZVActivityIndicatorView

class ViewController: UIViewController {

    @IBOutlet weak var innerActivityIndicatorView: ZVActivityIndicatorView!
    
    var outerActivityIndicatorView: ZVActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        innerActivityIndicatorView.strokColor = .white
        innerActivityIndicatorView.startAnimating()
        innerActivityIndicatorView.hidesWhenStopped = false
        
        let x = view.frame.width / 2.0 - 158.0 / 2.0
        let y = view.frame.height / 2.0 - 158.0 / 2.0
        
        outerActivityIndicatorView = ZVActivityIndicatorView(frame: .init(x: x, y: y, width: 158, height: 158))
        outerActivityIndicatorView?.strokColor = .black
        outerActivityIndicatorView?.progress = 0.75
        outerActivityIndicatorView?.strokeWidth = 3.0;
        outerActivityIndicatorView?.startAnimating()
        view.addSubview(outerActivityIndicatorView!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func startAnimating(_ sender: Any) {
        innerActivityIndicatorView.startAnimating()
        outerActivityIndicatorView?.startAnimating()
    }
    
    @IBAction func stopAnimating(_ sender: Any) {
        innerActivityIndicatorView.stopAnimating()
        outerActivityIndicatorView?.stopAnimating()
    }
}

