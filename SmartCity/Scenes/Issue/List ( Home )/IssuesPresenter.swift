//
//  IssuesPresenter.swift
//  SmartCity
//
//  Created by Salim Braksa on 1/28/18.
//  Copyright © 2018 Hidden Founders. All rights reserved.
//

import UIKit
import CoreLocation
import PromiseKit
import SwiftyJSON

class IssuesPresenter: IssuesPresenterInput {
    
    // MARK: Data
    
    private var data = [IssueViewModel]()
    private var preference = Preference.current
    
    // MARK: Dependencies
    
    unowned var view: IssuesViewInput
    private var findIssuesUseCase: FindIssuesUseCaseInput = FindIssuesUseCase()
    
    // MARK: Misc
    
    private var preferenceObservationToken: NSKeyValueObservation?
    private var createIssueParams = CreateIssueParams()
    private var parentIssuePromise: Promise<Issue?>.PendingTuple!
    
    // MARK: - Lifecycle
    
    init(view: IssuesViewInput) {
        self.view = view
        
        preferenceObservationToken = preference.observe(\.city) { [unowned self] (preference, nil) in
            self.view.update(withCityName: preference.city)
            self.viewDidLoad()
        }
        
    }
    
    deinit {
        preferenceObservationToken?.invalidate()
    }
    
    // MARK: - Input
    
    var numberOfItems: Int {
        return data.count
    }
    
    func viewDidLoad() {
        
        view.update(withCityName: preference.city)
        
        findIssuesUseCase.find(inCity: preference.city).then { [weak self] issues -> Void in
            guard let `self` = self else { return }
            self.data = issues.map { IssueViewModel(model: $0) }
            self.view.reload()
        }
        
    }
    
    func didPullRefreshControl() {
        
        findIssuesUseCase.find(inCity: preference.city).then { [weak self] issues -> Void in
            guard let `self` = self else { return }
            self.data = issues.map { IssueViewModel(model: $0) }
            self.view.reload()
            self.view.endRefreshing()
        }
        
    }
    
    func didEndTakingPicture(image: String) {
        createIssueParams.image = image
    }
    
    func didEndEditingDescription(description: String) {
        createIssueParams.description = description
         
        view.showActivity()
        self.parentIssuePromise = Promise<Issue?>.pending()
        let _ = filling(params: createIssueParams).then { params -> Promise<[Issue]> in
            if let coordinate = self.createIssueParams.coordinate {
                return Networking.request(target: .findSimilarIssues(coordinate)).map { try Issue.collection(from: $0) }
            } else {
                return Promise<[Issue]>(value: [])
            }
        }.then { [unowned self] issues -> Promise<Issue?> in
            if !issues.isEmpty {
                self.view.routeToIssueSelector(issues: issues)
                return self.parentIssuePromise.promise
            } else {
                return Promise<Issue?>(value: nil)
            }
        }.then { [unowned self] _ -> Promise<JSON> in
            return Networking.request(target: .createIssue(self.createIssueParams))
        }.then { [weak self] _ -> Void in
            self?.viewDidLoad()
        }.always { [weak self] in
            self?.view.hideActivity()
            self?.createIssueParams = CreateIssueParams()
        }
        
    }
    
    func didEndSelectingParentIssue(issue: Issue?) {
        createIssueParams.parent = issue
        parentIssuePromise.fulfill(issue)
        parentIssuePromise = nil
    }
    
    func didToggleConfirmButton(at indexPath: IndexPath) {
        let viewModel = data[indexPath.row]
        let increment = viewModel.confirmed ? -1 : 1
        viewModel.confirms += increment
        viewModel.set(confirmed: !viewModel.confirmed, notify: false)
        
        if viewModel.confirmed {
            Networking.request(target: .confirmIssue(viewModel.model.id))
        } else {
            Networking.request(target: .unconfirmIssue(viewModel.model.id))
        }
        
    }
    
    func configure(issueView: IssueViewInput, at indexPath: IndexPath) {
        let issue = data[indexPath.row]
        issueView.viewModel = issue
    }
    
    // MARK: - Helpers
    
    private func filling(params: CreateIssueParams) -> Promise<CreateIssueParams> {
        
        return CLLocationManager.promise().then { location -> Promise<CLPlacemark> in
            params.coordinate = location.coordinate
            return CLGeocoder().reverseGeocode(location: location)
        }.then { placemark -> Promise<CreateIssueParams> in
            if let city = placemark.administrativeArea {
                params.city = String(city.split(separator: "-").first ?? "").lowercased()
            }
            return Promise<CreateIssueParams>(value: params)
        }
        
    }
    
}

// MARK: -

protocol IssuesPresenterInput {
    
    var numberOfItems: Int { get }
    
    func viewDidLoad()
    
    func didPullRefreshControl()
    
    func didEndTakingPicture(image: String)
    
    func didEndEditingDescription(description: String)
    
    func didEndSelectingParentIssue(issue: Issue?)
    
    func didToggleConfirmButton(at indexPath: IndexPath)
    
    func configure(issueView: IssueViewInput, at indexPath: IndexPath)
    
}

// MARK: -

class CreateIssueParams {
    
    var coordinate: CLLocationCoordinate2D?
    var city: String?
    
    var description: String?
    var image: String?
    var parent: Issue?
    
    func toJSON() -> [String: Any] {
        
        var json = [String: Any]()
        
        json["city"] = city
        json["latitude"] = coordinate?.latitude
        json["longitude"] = coordinate?.longitude
        
        var issue = [String: Any]()
        issue["description"] = description
        issue["image"] = image
        issue["issue_id"] = parent?.id
        json["issue"] = issue
        
        return json
        
    }
    
}
