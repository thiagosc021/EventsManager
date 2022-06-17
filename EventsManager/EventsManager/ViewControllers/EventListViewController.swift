//
//  ViewController.swift
//  EventsManager
//
//  Created by Thiago Costa on 6/2/22.
//

import UIKit

enum Section: String, CaseIterable {
    case attending = "Attending"
    case notAttending = "Not Attending"
}

class EventListViewController: UIViewController {
    private var selectedEvent: Event?
    private var collectionView: UICollectionView! = nil
    private let modelController = EventModelController.shared
    private lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelController.fetch()
        configureCollectionView()
        loadSnapshot()
        configureNotificationConsumers()
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? EventDetailsViewController,
              let selectedEvent = self.selectedEvent else {
            return
        }
        
        destination.model = selectedEvent
        
    }
}

extension EventListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            selectedEvent = modelController.rsvpList[indexPath.row]
        } else {
            selectedEvent = modelController.notRsvpList[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "EventDetailSegue", sender: self)
    }
}

private extension EventListViewController {
    @objc
    func loadSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Event>()
        snapshot.appendSections([.attending])
        snapshot.appendItems(modelController.rsvpList)
        snapshot.appendSections([.notAttending])
        snapshot.appendItems(modelController.notRsvpList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    @objc
    func updateSnapshot(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let eventId = userInfo[NotificationKeys.eventId] as? UUID,
              let event = modelController.loadEvent(by: eventId) else {
            return
        }
        
        var snapshot = dataSource.snapshot()
        snapshot.reconfigureItems([event])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.anchor(top: self.view.topAnchor,
                              bottom: self.view.bottomAnchor,
                              leading: self.view.leadingAnchor,
                              trailing: self.view.trailingAnchor,
                              paddingTop: 100.0,
                              paddingBottom: 25.0,
                              paddingLeft: 10.0,
                              paddingRight: 10.0)
        collectionView.delegate = self
        collectionView.layer.cornerRadius = 12
        collectionView.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: EventCollectionViewCell.reuseIdentifier)
        collectionView.register(EventHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EventHeaderView.reuseIdentifier)
    }
    
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section,Event>{
        let dataSource = UICollectionViewDiffableDataSource<Section, Event>(collectionView: collectionView) { (collectionView, indexPath, event) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.reuseIdentifier, for: indexPath) as? EventCollectionViewCell else {
                fatalError("Could not create view cell")
            }
            
            cell.title = event.getEventDay()
            return cell
        }
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: EventHeaderView.reuseIdentifier, for: indexPath) as? EventHeaderView else {
                fatalError("Could not create supplementary View")
            }
            supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
            return supplementaryView
        }
        return dataSource
    }
    
    func configureNotificationConsumers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(loadSnapshot),
                                               name: .eventDidAdd,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSnapshot(_:)),
                                               name: .eventDidChange,
                                               object: nil)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: generateEventSectionLayout())
        return layout
    }
    
    func generateEventSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3,
                                                     leading: 10,
                                                     bottom: 3,
                                                     trailing: 10)
        
        let itemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .fractionalWidth(0.85))
        let itemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: itemGroupSize, subitem: item, count: 1)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: itemGroup)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
}
