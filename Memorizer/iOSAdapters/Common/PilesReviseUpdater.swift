import UIKit

public class PilesReviseUpdater {
    private var timer: Timer?
    private let updater: PilesReviseStateUpdater
    public init(_ updater: PilesReviseStateUpdater) {
        self.updater = updater
        NotificationCenter.default.addObserver(self, selector: #selector(becomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resignActive), name: UIApplication.willResignActiveNotification, object: nil)
    }
    func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 3 * 60, target: self,
                                     selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    @objc private func becomeActive() {
        updateState()
        startTimer()
    }
    @objc private func resignActive() {
        stopTimer()
    }
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc private func timerTick() {
        updateState()
    }
    private func updateState() {
        updater.updateReviseState()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
        stopTimer()
    }
}
