import Foundation
import iOSAdapters

protocol PileListOnboardingAnimator {
    func animatePileListOnboarding()
}
struct PileListOnboarding {
    
    private let maxCount = 3
    private let udKey = "com.memorizer.pilelistanimator"
    private let userDefaults = UserDefaults.standard
    
    private let animator: PileListOnboardingAnimator
    private let dataSource: PileListDataSource
    init(_ animator: PileListOnboardingAnimator, _ dataSource: PileListDataSource) {
        self.animator = animator
        self.dataSource = dataSource
    }
    
    func animateIfNeed() {
        guard dataSource.sectionsCount > 0 else { return }
        let animatedCount = userDefaults.integer(forKey: udKey)
        guard animatedCount < maxCount else { return }
        animator.animatePileListOnboarding()
        userDefaults.set(animatedCount + 1, forKey: udKey)
    }
}
