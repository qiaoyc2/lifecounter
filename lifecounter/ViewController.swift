//
//  ViewController.swift
//  lifecounter
//
//  Created by Katharina Cheng on 2/2/26.
//

import UIKit

class ViewController: UIViewController{

    
    @IBOutlet weak var allPlayerStacks: UIStackView!
    
    @IBOutlet weak var addPlayerBut: UIButton!
    @IBOutlet weak var deletePlayerBut: UIButton!
    
    @IBOutlet weak var gameEndText: UILabel!
    
    private var playersHP: [Int] = [20, 20, 20, 20]   // start with 4 players
    private let minPlayers = 2
    private let maxPlayers = 8
    private var gameStarted = false
    private var history: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // initialization
        gameEndText.text = ""
        
        syncUIToPlayers()
        print(" viewDidLoad ran")
        print(" playerBlocks count:", playerBlocks().count)
        updateTopButtons()

    }
    // add & delete function
    @IBAction func addPlayerTapped(_ sender: Any) {
        guard !gameStarted else { return }
        guard playersHP.count < maxPlayers else { return }

        playersHP.append(20)
        addPlayerBlockUI(forIndex: playersHP.count - 1)
        updateAllPlayerBlocks()
        updateTopButtons()
    }

    @IBAction func deletePlayerTapped(_ sender: Any) {
        guard !gameStarted else { return }
        guard playersHP.count > minPlayers else { return }
        playersHP.removeLast()
        removeLastPlayerBlockUI()
        updateAllPlayerBlocks()
        updateTopButtons()
    }
    
    private func syncUIToPlayers() {
        // 1) collect player blocks currently in storyboard
        var blocks = playerBlocks()

        // 2) if storyboard has more blocks than we need, remove extras
        while blocks.count > playersHP.count {
            removeLastPlayerBlockUI()
            blocks = playerBlocks()
        }

        // 3) if storyboard has fewer blocks than we need, add blocks
        while blocks.count < playersHP.count {
            addPlayerBlockUI(forIndex: blocks.count)
            blocks = playerBlocks()
        }

        // 4) update everything
        updateAllPlayerBlocks()
    }
    
    private func updateAllPlayerBlocks() {
        
        gameEndText.text = ""   // will be set by checkGameOver()
        let blocks = playerBlocks()
        print("blocks:", blocks.count)
        for i in 0..<blocks.count {
            configure(block: blocks[i], index: i)
        }
        checkGameOver()
    }
    
    private func configure(block: UIView, index: Int) {
        // Find labels/buttons inside this block
        let labels = allSubviews(of: block).compactMap { $0 as? UILabel }
        let buttons = allSubviews(of: block).compactMap { $0 as? UIButton }

        
        if let playerLabel = labels.first(where: { ($0.text ?? "").lowercased().contains("player") }) {
            playerLabel.text = "Player \(index + 1)"
        }
        if let lifeLabel = labels.first(where: { ($0.text ?? "").lowercased().contains("current life total") }) {
            lifeLabel.text = "current life total: \(playersHP[index])"
        }

        
        for b in buttons {
            // Use configuration title first (iOS 15+), fallback to old title API
            let raw = b.configuration?.title ?? b.title(for: .normal) ?? ""
            let title = raw.trimmingCharacters(in: .whitespacesAndNewlines)
                          .replacingOccurrences(of: " ", with: "")

            b.removeTarget(nil, action: nil, for: .allEvents)
            b.tag = index

            switch title {
            case "+":
                b.addTarget(self, action: #selector(plus1(_:)), for: .touchUpInside)
            case "-":
                b.addTarget(self, action: #selector(minus1(_:)), for: .touchUpInside)
            case "+by":
                b.addTarget(self, action: #selector(plusBy(_:)), for: .touchUpInside)
            case "-by":
                b.addTarget(self, action: #selector(minusBy(_:)), for: .touchUpInside)
            default:
                break
            }
        }

    }
    
    // Player Block Create/Remove
    private func addPlayerBlockUI(forIndex index: Int) {
        // Duplicate the LAST existing player block as a template
        guard let template = playerBlocks().last else { return }

        // Create a new stack view by "copying" via archiving
        // (works well for storyboard-built views)
        guard
            let data = try? NSKeyedArchiver.archivedData(withRootObject: template, requiringSecureCoding: false),
            let copy = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIView
        else { return }

        allPlayerStacks.addArrangedSubview(copy)
    }
    
    private func removeLastPlayerBlockUI() {
        guard let last = playerBlocks().last else { return }
        allPlayerStacks.removeArrangedSubview(last)
        last.removeFromSuperview()
    }

    private func playerBlocks() -> [UIView] {
        // Only treat arranged subviews with tag 999 as player blocks.
        allPlayerStacks.arrangedSubviews.filter { $0.tag == 7 }
    }

    // Button Handlers
    @objc private func plus1(_ sender: UIButton) {
        changeLife(for: sender.tag, delta: +1)
    }

    @objc private func minus1(_ sender: UIButton) {
        changeLife(for: sender.tag, delta: -1)
    }

    @objc private func plusBy(_ sender: UIButton) {
        promptForAmount(title: "Add Life", message: "Enter an amount to add") { [weak self] amount in
            self?.changeLife(for: sender.tag, delta: +amount)
        }
    }

    @objc private func minusBy(_ sender: UIButton) {
        promptForAmount(title: "Remove Life", message: "Enter an amount to remove") { [weak self] amount in
            self?.changeLife(for: sender.tag, delta: -amount)
        }
    }

    private func changeLife(for index: Int, delta: Int) {
        guard playersHP.indices.contains(index) else { return }

        if delta != 0 { gameStarted = true }

        playersHP[index] += delta

        // History hook (for later History screen)
        let verb = delta > 0 ? "gained" : "lost"
        let amount = abs(delta)
        history.append("Player \(index + 1) \(verb) \(amount) life.")

        updateAllPlayerBlocks()
        updateTopButtons()
    }
    
    // pop out
    private func promptForAmount(title: String, message: String, onSubmit: @escaping (Int) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addTextField { tf in
            tf.placeholder = "e.g. 7"
            tf.keyboardType = .numberPad
        }

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            guard let raw = alert.textFields?.first?.text else { return }
            let filtered = raw.filter(\.isNumber)      // enforce numeric only even if pasted
            guard filtered == raw, let amount = Int(raw), amount > 0 else { return }
            onSubmit(amount)
        })

        present(alert, animated: true)
    }
    
    // Game Over
    private func checkGameOver() {
        if let losingIndex = playersHP.firstIndex(where: { $0 <= 0 }) {
            gameEndText.text = "Player \(losingIndex + 1) LOSES!"
            // game is over -> allow add/delete again
            gameStarted = false
        } else {
            gameEndText.text = ""
        }
    }
    
    private func updateTopButtons() {
        // Add/Delete allowed only if game hasn't started AND within bounds
        let canEditPlayers = !gameStarted
        addPlayerBut.isEnabled = canEditPlayers && playersHP.count < maxPlayers
        deletePlayerBut.isEnabled = canEditPlayers && playersHP.count > minPlayers
    }

    // Utility
    private func allSubviews(of view: UIView) -> [UIView] {
        var result: [UIView] = []
        for sub in view.subviews {
            result.append(sub)
            result.append(contentsOf: allSubviews(of: sub))
        }
        return result
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHistory",
           let dest = segue.destination as? HistoryViewController {
            dest.history = history
        }
    }


}

