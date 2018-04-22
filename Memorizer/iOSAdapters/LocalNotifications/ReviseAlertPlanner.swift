public protocol AllPilesProvider {
    var allPiles: [PileItem] { get }
}
public class ReviseAlertPlanner: CurrentDateConsumer {
    let scheduler: LocalNotificationScheduler
    let allPilesProvider: AllPilesProvider
    public init(_ scheduler: LocalNotificationScheduler, _ allPilesProvider: AllPilesProvider) {
        self.scheduler = scheduler
        self.allPilesProvider = allPilesProvider
    }
}
extension ReviseAlertPlanner: PileItemRepositoryDelegate {
    public func onPileRemoved(at index: Int) {
        planOrRemoveLocalNotificationIfNeed()
    }
    private func planOrRemoveLocalNotificationIfNeed() {
        let notRevisablePiles = allPilesProvider.allPiles.filter({!$0.needToRevise})
        let revisablePiles = allPilesProvider.allPiles.filter({$0.needToRevise})
        if notRevisablePiles.isEmpty {
            scheduler.cancelNotification()
        }else if revisablePiles.isEmpty {
            scheduleAtNearestReviseDate(notRevisablePiles)
        }
    }
    private func scheduleAtNearestReviseDate(_ items: [PileItem]) {
        let canBeRevisedItems = items.filter({!$0.revisedMaxTime})
        guard canBeRevisedItems.count > 0 else { return }
        let sortedByIntervalTillAlert = canBeRevisedItems
            .sorted(by: {$0.intervalToRevise < $1.intervalToRevise})
        let alertDate = currentDateProvider.currentDate
            .addingTimeInterval(sortedByIntervalTillAlert.first!.intervalToRevise)
        scheduler.schedule(at: alertDate)
    }
    public func onPileAdded(pile: PileItem, at index: Int) {
        planOrRemoveLocalNotificationIfNeed()
    }
    public func onPileChanged(pile: PileItem, at index: Int) {
        planOrRemoveLocalNotificationIfNeed()
    }
    public func onPilesFetched(_ pileItems: [PileItem]) {
        planOrRemoveLocalNotificationIfNeed()
    }
}
extension PileItem {
    var intervalToRevise: TimeInterval {
        let index = min(max(revisedCount, 0), PileItem.intervals.count - 1)
        return TimeInterval(PileItem.intervals[index] - currentDateProvider.currentDate
            .timeIntervalSince(revisedDate ?? createdDate))
    }
    var revisedMaxTime: Bool {
        return revisedCount >= PileItem.intervals.count - 1
    }
}
