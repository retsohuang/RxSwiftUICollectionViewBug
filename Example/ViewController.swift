//
//  ViewController.swift
//  Example
//
//  Created by Krunoslav Zaher on 1/1/16.
//  Copyright © 2016 kzaher. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import RxCocoa
import CoreLocation

class NumberCell : UICollectionViewCell {
    @IBOutlet var value: UILabel?
}

class NumberSectionView : UICollectionReusableView {
    @IBOutlet weak var value: UILabel?
}

class ViewController: UICollectionViewController {

    let disposeBag = DisposeBag()

    override func viewDidLoad() {
      super.viewDidLoad()

      // Should set nil if you use UICollectionViewController
      collectionView?.dataSource = nil
      
      let randomSections = Observable.just(initialValue())
      let cvReloadDataSource = RxCollectionViewSectionedReloadDataSource<NumberSection>()
      skinCollectionViewDataSource(cvReloadDataSource)
      randomSections
        .bindTo(collectionView!.rx_itemsWithDataSource(cvReloadDataSource))
        .addDisposableTo(disposeBag)
    }

    // MARK: Skinning

    func skinTableViewDataSource(dataSource: RxTableViewSectionedDataSource<NumberSection>) {
        dataSource.configureCell = { (_, tv, ip, i) in
            let cell = tv.dequeueReusableCellWithIdentifier("Cell") ?? UITableViewCell(style:.Default, reuseIdentifier: "Cell")

            cell.textLabel!.text = "\(i)"

            return cell
        }

        dataSource.titleForHeaderInSection = { (ds, section) -> String? in
            return ds.sectionAtIndex(section).header
        }
    }

    func skinCollectionViewDataSource(dataSource: CollectionViewSectionedDataSource<NumberSection>) {
        dataSource.cellFactory = { (_, cv, ip, i) in
            let cell = cv.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: ip) as! NumberCell

            cell.value!.text = "\(i)"

            return cell
        }

        dataSource.supplementaryViewFactory = { (ds ,cv, kind, ip) in
            let section = cv.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "Section", forIndexPath: ip) as! NumberSectionView

            section.value!.text = "\(ds.sectionAtIndex(ip.section).header)"
            
            return section
        }
    }

    // MARK: Initial value

    func initialValue() -> [NumberSection] {
        let generate = true
        if generate {

            let nSections = 10
            let nItems = 100


            /*
            let nSections = 10
            let nItems = 2
            */

            return (0 ..< nSections).map { (i: Int) in
                NumberSection(header: "Section \(i + 1)", numbers: $(Array(i * nItems ..< (i + 1) * nItems)), updated: NSDate())
            }
        }
        else {
            return _initialValue
        }
    }


    let _initialValue: [NumberSection] = [
        NumberSection(header: "section 1", numbers: $([1, 2, 3]), updated: NSDate()),
        NumberSection(header: "section 2", numbers: $([4, 5, 6]), updated: NSDate()),
        NumberSection(header: "section 3", numbers: $([7, 8, 9]), updated: NSDate()),
        NumberSection(header: "section 4", numbers: $([10, 11, 12]), updated: NSDate()),
        NumberSection(header: "section 5", numbers: $([13, 14, 15]), updated: NSDate()),
        NumberSection(header: "section 6", numbers: $([16, 17, 18]), updated: NSDate()),
        NumberSection(header: "section 7", numbers: $([19, 20, 21]), updated: NSDate()),
        NumberSection(header: "section 8", numbers: $([22, 23, 24]), updated: NSDate()),
        NumberSection(header: "section 9", numbers: $([25, 26, 27]), updated: NSDate()),
        NumberSection(header: "section 10", numbers: $([28, 29, 30]), updated: NSDate())
    ]
}

func $(numbers: [Int]) -> [IntItem] {
    return numbers.map { IntItem(number: $0, date: NSDate()) }
}

