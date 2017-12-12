import RealmSwift
import IGListKit

final internal class ListDataController: NSObject, ListAdapterDataSource {
    private let updater = ListAdapterUpdater()
    private let adapter: ListAdapter
    private var usersResults: Results<User> {
        didSet {
            resultsToken = usersResults.observe(usersObserveHandler)
        }
    }
    
    private var hobbiesResults: Results<Hobby> {
        didSet {
            hobbiesResultsToken = hobbiesResults.observe(hobbiesObserveHandler)
        }
    }
    
    private var users = [User]()
    private var resultsToken: NotificationToken?
    
    private var hobbies = [Hobby]()
    private var  hobbiesResultsToken: NotificationToken?
    
    private(set) var emptyListViewController: EmptyListViewController?
    
    private let realm = try! Realm()
    
    var filterPredicate: NSPredicate? {
        didSet {
            if let predicate = filterPredicate {
                usersResults = usersResults.filter(predicate)
            }
        }
    }
    
    override init() {
        fatalError("Please use init with collection view or table view and view controller")
    }
    
    init(collectionView: UICollectionView?,
         viewController: UIViewController,
         filterPredicate: NSPredicate? = nil) {
        
        emptyListViewController = EmptyListViewController()
        
        adapter = ListAdapter(updater: updater, viewController: viewController)
        adapter.collectionView = collectionView
        usersResults = realm.objects(User.self)
        hobbiesResults = realm.objects(Hobby.self)
        super.init()
        resultsToken = usersResults.observe(usersObserveHandler)
        hobbiesResultsToken = hobbiesResults.observe(hobbiesObserveHandler)
        self.filterPredicate = filterPredicate
        
        adapter.dataSource = self
    }
    
    private func performFilter(_ predicate: NSPredicate?) {
        resetResults()
        filterPredicate = predicate
    }
    
    private func usersObserveHandler(changes: RealmCollectionChange<Results<User>>) {
        self.users = Array(usersResults)
        self.adapter.performUpdates(animated: true)
    }
    
    private func hobbiesObserveHandler(changes: RealmCollectionChange<Results<Hobby>>) {
        self.hobbies = Array(hobbiesResults)
        self.adapter.performUpdates(animated: true)
    }
    
    public func resetResults() {
        usersResults = realm.objects(User.self)
        hobbiesResults = realm.objects(Hobby.self)
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return (users as [ListDiffable]) + (hobbies as [ListDiffable])
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is User {
            return UsersSectionController()
        }
        else {
            let hobbyController = HobbiesSectionController()
            hobbyController.filterDataAction = performFilter
            return hobbyController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyListViewController?.view
    }
}

