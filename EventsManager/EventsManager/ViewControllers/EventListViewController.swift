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

    private var collectionView: UICollectionView! = nil
    private let modelController = EventModelController.shared
    private lazy var dataSource = configureDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelController.fetch()
        configureCollectionView()
        snapshotForCurrentState()
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.anchor(top: self.view.topAnchor
                              , bottom: self.view.bottomAnchor
                              , leading: self.view.leadingAnchor
                              , trailing: self.view.trailingAnchor
                              , paddingTop: 100.0, paddingBottom: 25.0, paddingLeft: 20.0, paddingRight: 20.0)
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
            
            cell.title = event.name
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
    
    func snapshotForCurrentState() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Event>()
        snapshot.appendSections([.attending])
        snapshot.appendItems(modelController.rsvpList)
        snapshot.appendSections([.notAttending])
        snapshot.appendItems(modelController.notRsvpList)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: generateEventSectionLayout())
        return layout
    }
    
    func generateEventSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 3,
                                                     leading: 3,
                                                     bottom: 3,
                                                     trailing: 3)
        
        
        let itemGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let itemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: itemGroupSize, subitem: item, count: 2)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: itemGroup)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }

}

extension EventListViewController: UICollectionViewDelegate {
    
}
