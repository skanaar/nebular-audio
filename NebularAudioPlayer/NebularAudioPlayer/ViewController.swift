import UIKit

class ViewController: UIViewController {
    
    let musicPlayer = MusicPlayer()
    var timer: Timer?
    
    @IBAction func playMusicA(_ sender: Any) {
        musicPlayer.playMusic(file: "planet sand", crossFade: 10)
    }
    
    @IBAction func playMusicB(_ sender: Any) {
        musicPlayer.playMusic(file: "space fight", crossFade: 0.5)
    }
    
    @IBAction func playMusicC(_ sender: Any) {
        musicPlayer.playMusic(file: "star sky", crossFade: 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func update() {
        let fps = 20.0
        musicPlayer.update(dt: 1.0/fps)
        timer = Timer.scheduledTimer(timeInterval: 1.0/fps, target: self,
                                         selector: #selector(update), userInfo: nil,
                                         repeats: false)
    }
}
