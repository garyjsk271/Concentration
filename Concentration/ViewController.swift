//
//  ViewController.swift
//  Concentration
//
//  Created by Gary Kim on 3/28/20.
//  Copyright © 2020 Gary Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game = Concentration(nPairsOfCards: nPairsofCards, nEmojiThemes: emojiThemes.count)
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    var nPairsofCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedString.Key : Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)",
                attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
       
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel()
        }
    }
    
    private func updateScoreLabel() {
           let attributes: [NSAttributedString.Key : Any] = [
               .strokeWidth : 5.0,
               .strokeColor : #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
           ]
           let attributedString = NSAttributedString(string: "Score: \(game.score)",
                   attributes: attributes)
           scoreLabel.attributedText = attributedString
    }
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
        }
        if !game.isOver() {
            game.incrementFlipCount()
        }
        updateViewFromModel()
    }
    
    @IBAction func touchNewGameButton(_ sender: UIButton) {
        game.reset(nPairsOfCards: nPairsofCards, nEmojiThemes: emojiThemes.count)
        emoji.removeAll()
        theme.removeAll()
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if (card.isFaceUp) {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
        updateFlipCountLabel()
        updateScoreLabel()
    }
    
    private var emojiThemes = ["😼🍫🕷🦇🍎😈🎃👻",
                                "🦔🦉🐬🦧🐘🐏🐖🐒",
                                "⚽️🏀🏈🥎🥏🎱🏸🏒",
                                "🏛🏨🏤🕍🏭🏡🕌🏢",
                                "⌚️☎️🎛🎙🧭📺📽💻",
                                "🏳️‍🌈🇦🇮🇨🇦🇧🇷🇯🇵🇺🇸🇰🇷🇹🇼"]
    private var theme = String()
    private var emoji = [Card:String]()
    
    private func emoji(for card: Card) -> String {
        if (theme.isEmpty) {
            theme = emojiThemes[game.emojiThemeIdentifier]
        }
        if emoji[card] == nil, emojiThemes[game.emojiThemeIdentifier].count > 0 {
            let randomStringIndex = theme.index(theme.startIndex, offsetBy: theme.count.arc4random)
            emoji[card] = String(theme.remove(at: randomStringIndex))
        }
        return emoji[card]!
    }
}

extension Int {
    var arc4random: Int {
        return
            self > 0 ? Int(arc4random_uniform(UInt32(self)) ) :
            self < 0 ? -abs(self).arc4random : 0
    }
}
