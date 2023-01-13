//
//  TableView+NibLoader.swift
//  Walley
//
//  Created by Pavel Sharkov on 01.05.2022.
//

import UIKit

//MARK: - UITableViewCell -

extension UITableViewCell: NibLoadableView {}

extension UITableViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func registerNib<T: UITableViewCell>(cellType _: T.Type) {
        register(UINib(nibName: T.nibName, bundle: nil), forCellReuseIdentifier: T.reuseIdentifier)
    }

    func dequeCell<T: UITableViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withIdentifier: T.nibName, for: indexPath) as? T else {
            return nil
        }
        return cell
    }
}

//MARK: - UITableViewHeaderFooterView -

extension UITableViewHeaderFooterView: NibLoadableView {}

extension UITableViewHeaderFooterView {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UITableView {
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(headerFooterType _: T.Type) {
        register(UINib(nibName: T.nibName, bundle: nil), forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    func dequeHeaderFooter<T: UITableViewHeaderFooterView>() -> T? {
        guard let headFoot = dequeueReusableHeaderFooterView(withIdentifier: T.nibName) as? T else {
            return nil
        }
        return headFoot
    }
}

//MARK: - UICollectionViewCell -

extension UICollectionViewCell: NibLoadableView {}

extension UICollectionViewCell {
    static var reuseIdentifier: String { return String(describing: self) }
}

extension UICollectionView {
    func registerNib<T: UICollectionViewCell>(_: T.Type) {
        register(UINib(nibName: T.nibName, bundle: nil), forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.nibName, for: indexPath) as? T else {
            return nil
        }

        return cell
    }
}

protocol NibLoadableView {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
