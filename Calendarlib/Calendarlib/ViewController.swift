//
//  ViewController.swift
//  Calendarlib
//
//  Created by amoyio on 2018/10/2.
//  Copyright © 2018 amoyio. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CalendarCell.self), for: indexPath) as! CalendarCell
        cell.dayLabel.text = "1"
        cell.monthLabel.text = "Aug"
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = UICollectionViewFlowLayout()
        let calView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        calView.register(CalendarCell.self, forCellWithReuseIdentifier: NSStringFromClass(CalendarCell.self))
        view.addSubview(calView)
        calView.translatesAutoresizingMaskIntoConstraints = false
        calView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        calView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        calView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        calView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        calView.delegate = self
        calView.dataSource = self
        
        calView.backgroundColor = .red
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
