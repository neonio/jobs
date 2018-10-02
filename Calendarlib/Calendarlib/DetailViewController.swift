//
//  DetailViewController.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit
class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        title = "DetailViewController"
    }
    
    static func create() -> DetailViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController")
        return vc as! DetailViewController
    }
}
