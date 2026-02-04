//
//  HistoryViewController.swift
//  lifecounter
//
//  Created by Katharina Cheng on 2/4/26.
//

import UIKit

class HistoryViewController: UIViewController {

    
    @IBOutlet weak var backBut: UIButton!
    @IBOutlet weak var historyStack: UIStackView!
    
    var history: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        renderHistory()
    }
    
    private func renderHistory() {
        // clear old labels if coming back / reusing
        historyStack.arrangedSubviews.forEach { v in
            historyStack.removeArrangedSubview(v)
            v.removeFromSuperview()
        }

        for event in history.reversed() {
            let label = UILabel()
            label.text = "• \(event)"
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            historyStack.addArrangedSubview(label)
        }
        

    }
    
  
    @IBAction func backTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
