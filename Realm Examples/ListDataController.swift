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
        
        //Initial queries
        usersResults = realm.objects(User.self)
        hobbiesResults = realm.objects(Hobby.self)
        super.init()
        
        //Assign observers to tokens so that they stay in memory as long as
        //the data controller exists, otherwise no observations would happen
        resultsToken = usersResults.observe(usersObserveHandler)
        hobbiesResultsToken = hobbiesResults.observe(hobbiesObserveHandler)
        self.filterPredicate = filterPredicate
        
        adapter.dataSource = self
    }
    
    private func performFilter(_ predicate: NSPredicate?) {
        //Reset the Realm "query" so that we don't filter on top of a filter
        //which would have the same effect as running one large query with
        //multiple AND operations
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
        //Mix and match model data types in the list
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

