//
//  GameScene.swift
//  Jogo Circulo
//
//  Created by André Brilho on 31/10/15.
//  Copyright (c) 2015 classroomM. All rights reserved.
//

import SpriteKit

struct CategoriasContato {
    
    static let inimigos : UInt32 = 0x1 << 0
    static let tiro : UInt32 = 0x1 << 1
    static let bolaPrincipal : UInt32 = 0x1 << 2
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
     var Mainball = SKSpriteNode(imageNamed: "bola")
    
    var TempoInimigos = NSTimer()
    var hits = 0
    var startGame = false
    
    var lblIniciar = SKLabelNode(fontNamed: "STHeitiJ-Medium")
    var scoreLabel = SKLabelNode(fontNamed: "STHeitiJ-Medium")
    var HighScoreLabel = SKLabelNode(fontNamed: "STHeitiJ-Medium")
    
    var Score = 0
    var HScore = 0
    
    var Fading = SKAction()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
       
        self.physicsWorld.contactDelegate = self
        
        let HighscoreDefault = NSUserDefaults.standardUserDefaults()
        
        if HighscoreDefault.valueForKey("Recorde") != nil {
        
        HScore = HighscoreDefault.valueForKey("Recorde") as! Int
            HighScoreLabel.text = "Recorde : \(HScore)"
        
        }
        
        lblIniciar.text = "Tap to Play"
        lblIniciar.fontSize = 34
        lblIniciar.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        lblIniciar.fontColor = UIColor.whiteColor()
        lblIniciar.zPosition = 2.0
        self.addChild(lblIniciar)
        
        Fading = SKAction.sequence([SKAction.fadeInWithDuration(1.0), SKAction.fadeOutWithDuration(1.0)])
        lblIniciar.runAction(SKAction.repeatActionForever(Fading))
        
        HighScoreLabel.text = "Recorde : \(HScore)"
        HighScoreLabel.position = CGPoint(x: frame.width / 2, y: frame.height / 1.3)
        HighScoreLabel.fontColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        self.addChild(HighScoreLabel)
        
        scoreLabel.alpha = 0
        scoreLabel.fontSize = 35
        scoreLabel.position = CGPoint(x: frame.width / 2, y: frame.height / 1.3)
        scoreLabel.fontColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        
        scoreLabel.text = "\(Score)"
        self.addChild(scoreLabel)
        
        
        backgroundColor = UIColor.whiteColor()
       

        Mainball.size = CGSize(width: 225, height: 225)
        Mainball.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        Mainball.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        Mainball.colorBlendFactor = 1.0
        
        Mainball.zPosition = 1.0
        
        Mainball.physicsBody = SKPhysicsBody(circleOfRadius: Mainball.size.width / 2)
        Mainball.physicsBody?.categoryBitMask = CategoriasContato.tiro
        Mainball.physicsBody?.collisionBitMask = CategoriasContato.inimigos
        Mainball.physicsBody?.contactTestBitMask = CategoriasContato.inimigos
        Mainball.physicsBody?.affectedByGravity = false
        Mainball.physicsBody?.dynamic = false
        Mainball.name = "MainBall"
        
        self.addChild(Mainball)
        

        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        if contact.bodyA.node != nil && contact.bodyB.node != nil {
        
        let Contato1 = contact.bodyA.node as! SKSpriteNode
        let Contato2 = contact.bodyB.node as! SKSpriteNode
        
        if ((Contato1.name == "Inimigos") && (Contato2.name == "SmallBall")){
        
        ColisaoTiro(Contato1, SmallBall: Contato2)
        
            
        } else if ((Contato1.name == "SmallBall") && (Contato2.name == "Inimigos")) {
        
            ColisaoTiro(Contato2, SmallBall: Contato1)
            
        }
        
        else if ((Contato1.name == "MainBall") && (Contato2.name == "Inimigos")){
        
            ColisaoCentro(Contato2)
            
        } else if ((Contato1.name == "Inimigos") && (Contato2.name == "MainBall")){
        
            ColisaoCentro(Contato1)
        
        }
            
        }
        
    }
    
    func ColisaoTiro(inimigo : SKSpriteNode, SmallBall : SKSpriteNode) {
    
    inimigo.physicsBody?.dynamic = true
        inimigo.physicsBody?.affectedByGravity = true
        inimigo.physicsBody?.mass = 5.0
        SmallBall.physicsBody?.mass = 5.0
        
        SmallBall.removeAllActions()
        inimigo.removeAllActions()
        inimigo.physicsBody?.contactTestBitMask = 0
       //inimigo.name = nil
        inimigo.physicsBody?.collisionBitMask = 0
        
        Score++
        scoreLabel.text = "\(Score)"
        
        
        
        
    }
    
    
    func ColisaoCentro(Inimigos : SKSpriteNode){
    

        
        if hits < 3 {
        
        Mainball.runAction(SKAction.scaleBy(1.5, duration: 0.4))
        Inimigos.physicsBody?.affectedByGravity = true
            Inimigos.removeAllActions()
            
            Mainball.runAction(SKAction.sequence([SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.1), SKAction.colorizeWithColor(SKColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.1)]))

            hits++
            Inimigos.removeFromParent()
            
        
        }
            
            
        
        else {
        
            Inimigos.removeFromParent()
            TempoInimigos.invalidate()
           startGame = false
            
            scoreLabel.runAction(SKAction.fadeOutWithDuration(0.2))
            lblIniciar.runAction(SKAction.fadeInWithDuration(1.0))
            lblIniciar.runAction(SKAction.repeatActionForever(Fading))
            HighScoreLabel.runAction(SKAction.fadeInWithDuration(0.2))
            
            if Score > HScore {
            let highScoredefaul = NSUserDefaults.standardUserDefaults()
                HScore = Score
                highScoredefaul.setInteger(HScore, forKey: "Recorde")
                HighScoreLabel.text = "Recorde : \(HScore)"
            }
            
            
        
        }
        
    
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if startGame == false {
        
          TempoInimigos = NSTimer.scheduledTimerWithTimeInterval(0.7, target: self, selector: Selector("Inimigos"), userInfo: nil, repeats: true)
            startGame = true
            Mainball.runAction(SKAction.scaleTo(0.44, duration: 0.2))
            hits = 0
            
            
            lblIniciar.removeAllActions()
            lblIniciar.runAction(SKAction.fadeOutWithDuration(0.2))
            HighScoreLabel.runAction(SKAction.fadeOutWithDuration(0.2))
            
            scoreLabel.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.fadeInWithDuration(1.0)]))
            
            Score = 0
            scoreLabel.text = "\(Score)"
            
        }
        else {
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            let Smallball = SKSpriteNode(imageNamed: "bola")
            
            Smallball.position = Mainball.position
            
            Smallball.size = CGSize(width: 30, height: 30)
            
            Smallball.physicsBody = SKPhysicsBody(circleOfRadius: Smallball.size
            .width / 2)
            Smallball.physicsBody?.affectedByGravity = false
            Smallball.color = UIColor(red: 0.1, green: 0.65, blue: 0.95, alpha: 1.0)
            Smallball.colorBlendFactor = 1.0
            
           Smallball.physicsBody?.categoryBitMask = CategoriasContato.tiro
           Smallball.physicsBody?.collisionBitMask = CategoriasContato.inimigos
           Smallball.physicsBody?.contactTestBitMask = CategoriasContato.inimigos
            Smallball.name = "SmallBall"
            
             self.addChild(Smallball)
            
            Smallball.physicsBody?.dynamic = true
            Smallball.physicsBody?.affectedByGravity = false
            
            var dx = CGFloat(location.x - Mainball.position.x)
            var dy = CGFloat(location.y - Mainball.position.y)
            
            let magnitude = sqrt(dx * dx + dy * dy)
            
            dx /= magnitude
            dy /= magnitude
            
            let vector = CGVector(dx: 30.0 * dx, dy: 30.0 * dy)
            
            Smallball.physicsBody?.applyImpulse(vector)
            
            
            }
            
        }
    }
   
    
    func Inimigos(){
    
        let inimigos = SKSpriteNode(imageNamed: "bola")
        inimigos.size = CGSize(width: 20, height: 20)
        inimigos.color = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)
        inimigos.colorBlendFactor = 1.0
        
        
        //Contatos
        
        inimigos.physicsBody = SKPhysicsBody(circleOfRadius: inimigos.size.width / 2)
        inimigos.physicsBody?.categoryBitMask = CategoriasContato.inimigos
       inimigos.physicsBody?.contactTestBitMask = CategoriasContato.tiro | CategoriasContato.bolaPrincipal
        inimigos.physicsBody?.collisionBitMask = CategoriasContato.tiro | CategoriasContato.bolaPrincipal
        inimigos.physicsBody?.affectedByGravity = false
        inimigos.physicsBody?.dynamic = true
        inimigos.name = "Inimigos"
        

        
        
        //colocar em lugares aleatorios da tela
        let PosAleatoria = arc4random() % 4

        switch PosAleatoria{
        
        case 0:
            
            inimigos.position.x = 0
            
            var posicaoY = arc4random_uniform(UInt32(frame.size.height))
            
            inimigos.position.y = CGFloat(posicaoY)
            
            self.addChild(inimigos)
            break
        case 1:
            
            
            inimigos.position.y = 0
            
            var posicaoX = arc4random_uniform(UInt32(frame.size.width))
            
            inimigos.position.x = CGFloat(posicaoX)
            
            self.addChild(inimigos)
            
            break
        case 2:
            
            inimigos.position.y = frame.size.height
            
            var posicaoX = arc4random_uniform(UInt32(frame.size.width))
            
            inimigos.position.x = CGFloat(posicaoX)
            
            self.addChild(inimigos)
    
            
            break
        case 3:
            
            
            inimigos.position.x = frame.size.width
            
            var posicaoY = arc4random_uniform(UInt32(frame.size.height))
            
            inimigos.position.y = CGFloat(posicaoY)
            
            self.addChild(inimigos)

            
            break
        default:
            
            break
            
        }
        
        inimigos.runAction(SKAction.moveTo(Mainball.position, duration: 3))
    
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
