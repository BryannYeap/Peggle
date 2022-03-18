protocol PegEngineUpdateDelegate: AnyObject {
    func didUpdatePegEngine()
    func didAddNewGameObject(_ gameObject: GameObject)
    func didWinGame()
    func didLoseGame()
    func didExplode()
    func didSpookyball()
    func didFreeBall()
    func didShootCannonball()
}
