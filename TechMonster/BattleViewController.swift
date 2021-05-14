//
//  BattleViewController.swift
//  TechMonster
//
//  Created by 安念　玉希 on 2021/05/15.
//

import UIKit

class BattleViewController: UIViewController {
    
    var enemyAtacckTimer: Timer!
    
    var enemy: Enemy!
    var player: Player!
    
    @IBOutlet var attackButton: UIButton!
    
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var playerImageView: UIImageView!
    
    @IBOutlet var enemyHPBar: UIProgressView!
    @IBOutlet var playerHPBar: UIProgressView!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var playerNameLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        enemyHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)
        playerHPBar.transform = CGAffineTransform(scaleX: 1.0, y: 4.0)

        playerNameLabel.text = player.name
        playerImageView.image = player.image
        playerHPBar.progress = player.currentHP / player.maxHP
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startBattle()
    }
    
    func startBattle(){
        TechDraUtil.playBGM(fileName: "BGM_battle001")
        
        enemy = Enemy()
        
        enemyNameLabel.text = enemy.name
        enemyImageView.image = enemy.image
        enemyHPBar.progress = enemy.currentHP / enemy.maxHP
        
        attackButton.isHidden = false
        
        enemyAtacckTimer = Timer.scheduledTimer(timeInterval: enemy.attackInterval, target: self, selector: #selector(enemyAttack), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func playerAttack(){
        TechDraUtil.animateDamage(enemyImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        enemy.currentHP = enemy.currentHP - player.attackPower
        enemyHPBar.setProgress(enemy.currentHP / enemy.maxHP, animated: true)
        
        if enemy.currentHP < 0{
            TechDraUtil.animateDamage(enemyImageView)
            finishBattle(isPlayerWin: true)
        }
    }
    
    func finishBattle(isPlayerWin: Bool){
        TechDraUtil.stopBGM()
        
        attackButton.isHidden = true
        
        enemyAtacckTimer.invalidate()
        
        let finishedMessage: String
        if isPlayerWin {
            TechDraUtil.playSE(fileName: "SE_fanfare")
            finishedMessage = "プレイヤーの勝利"
        } else {
            TechDraUtil.playSE(fileName: "SE_gameover")
            finishedMessage = "プレイヤーの敗北..."
        }
        
        let alert = UIAlertController(title: "バトル終了！", message: finishedMessage, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { action in self.dismiss(animated: true, completion: nil)
            
        })
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    @objc func enemyAttack(){
        TechDraUtil.animateDamage(playerImageView)
        TechDraUtil.playSE(fileName: "SE_attack")
        
        player.currentHP = player.currentHP - player.attackPower
        playerHPBar.setProgress(player.currentHP / player.maxHP, animated: true)
        
        if player.currentHP < 0{
            TechDraUtil.animateVanish(playerImageView)
            finishBattle(isPlayerWin: false)
        }
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

