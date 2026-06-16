import Foundation

class GameTimer {

    private var timer: Timer?
    private var secondsLeft: Int = 0

//timer da discussao
    func startDiscussion(
        duration: Int,
        onTick: @escaping (Int) -> Void,
        onFinish: @escaping () -> Void
    ) {
        stop()
        secondsLeft = duration
        start(onTick: onTick, onFinish: onFinish)
    }

//Timer da votaacao
    func startVoting(
        duration: Int,
        onTick: @escaping (Int) -> Void,
        onFinish: @escaping () -> Void
    ) {
        stop()
        secondsLeft = duration
        start(onTick: onTick, onFinish: onFinish)
    }

//invalida o timer caso o host mande
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    //host pode adicionar tmpo
    func addTime(_ seconds: Int){
        secondsLeft += seconds
    }


    private func start(
        onTick: @escaping (Int) -> Void,
        onFinish: @escaping () -> Void
    ) {
        //O weak self evita q retain cycle, ou seja o timer nao segura o GameTiemer na memoria dps de parar.
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }

            if self.secondsLeft > 0 {
                self.secondsLeft -= 1
                onTick(self.secondsLeft)
            } else {
                print("TIMER FINALIZOU")
                self.stop()
                onFinish()
            }
        }
    }
}
