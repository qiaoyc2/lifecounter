//
//  ViewController.swift
//  lifecounter
//
//  Created by Katharina Cheng on 2/2/26.
//

import UIKit

class ViewController: UIViewController{
    
    var p1HP: Int = 20
    var p2HP: Int = 20
//    var gameOverShown: Bool = false

    @IBOutlet weak var plusforplayer2: UIButton!
    @IBOutlet weak var minusforplayer2: UIButton!
    @IBOutlet weak var plusfiveforp2: UIButton!
    @IBOutlet weak var minusfiveforp2: UIButton!
    @IBOutlet weak var lifeforp2: UILabel!
    
    @IBOutlet weak var lifeforp1: UILabel!
    @IBOutlet weak var plusforplayer1: UIButton!
    @IBOutlet weak var minusforplayer1: UIButton!
    @IBOutlet weak var plusfiveforplayer1: UIButton!
    @IBOutlet weak var minusfiveforplayer1: UIButton!
    
    @IBOutlet weak var gameEndText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialization
        lifeforp1.text = "current life total: \(p1HP)"
        lifeforp2.text = "current life total: \(p2HP)"
        gameEndText.text = ""
        //adjust for player 1 HP
        plusforplayer1.addTarget(self,
                                 action: #selector(plus1forp1),
                                 for: .touchUpInside)
        minusforplayer1.addTarget(self,
                                  action: #selector(minus1forp1),
                                  for: .touchUpInside)
        plusfiveforplayer1.addTarget(self,
                                     action: #selector(plus5forp1),
                                     for: .touchUpInside)
        minusfiveforplayer1.addTarget(self,
                                      action: #selector(minus5forp1),
                                      for: .touchUpInside)
        
        
        // adjust for player 2 HP
        plusforplayer2.addTarget(self,
                                 action: #selector(plus1forp2),
                                 for: .touchUpInside)
        minusforplayer2.addTarget(self,
                                  action: #selector(minus1forp2),
                                  for: .touchUpInside)
        plusfiveforp2.addTarget(self,
                                action: #selector(plus5forp2),
                                for: .touchUpInside)
        minusfiveforp2.addTarget(self,
                                 action: #selector(minus5forp2),
                                 for: .touchUpInside)
        

    }
    
    
    @IBAction func plus1forp1(_ sender: Any) {
        p1HP += 1
        checkGameOver()
        lifeforp1.text = "current life total: \(p1HP)"
    }
    @IBAction func minus1forp1(_ sender: Any) {
        p1HP -= 1
        checkGameOver()
        lifeforp1.text = "current life total: \(p1HP)"
        
    }
    @IBAction func plus5forp1(_ sender: Any) {
        p1HP += 5
        checkGameOver()
        lifeforp1.text = "current life total: \(p1HP)"
    }
    @IBAction func minus5forp1(_ sender: Any) {
        p1HP -= 5
        checkGameOver()
        lifeforp1.text = "current life total: \(p1HP)"
   
    }
    
    @IBAction func plus1forp2(_ sender: Any) {
        p2HP += 1
        checkGameOver()
        lifeforp2.text = "current life total: \(p2HP)"
    }
    @IBAction func minus1forp2(_ sender: Any) {
        p2HP -= 1
        checkGameOver()
        lifeforp2.text = "current life total: \(p2HP)"
        
    }
    @IBAction func plus5forp2(_ sender: Any) {
        p2HP += 5
        checkGameOver()
        lifeforp2.text = "current life total: \(p2HP)"
    }
    @IBAction func minus5forp2(_ sender: Any) {
        p2HP -= 5
        checkGameOver()
        lifeforp2.text = "current life total: \(p2HP)"
      
    }
    
//    private func showLoserPopup(player: Int) {
//        let alert = UIAlertController(
//            title: "Game Over",
//            message: "Player \(player) LOSES!",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
    
    private func checkGameOver() {
//        guard !gameOverShown else { return }

        if p1HP <= 0 {
            gameEndText.text = "Player 1 LOSES!"

//            gameOverShown = true
//            showLoserPopup(player: 1)
        } else if p2HP <= 0 {
            gameEndText.text = "Player 2 LOSES!"
//            gameOverShown = true
//            showLoserPopup(player: 2)
        } else {
            gameEndText.text = ""
        }
    }

}

