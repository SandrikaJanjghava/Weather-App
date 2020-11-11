//
//  DailyWeatherViewController.swift
//  Weather App
//
//  Created by Sandro janjghava on 11/7/20.
//

import UIKit

class DailyWeatherViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Properties
    private let reuseIdentifier = "DailyTableViewCell"
    private var dataSource: [Date: [Hourly]] = [:]
    var filteredData: ForecastWeatherType? {
        didSet {
            self.createDataSource()
        }
    }
    private var houlry: [Hourly] {
        return filteredData?.hourly ?? []
    }
    
    static func load(with filteredData: ForecastWeatherType?) -> DailyWeatherViewController {
        let controller = UIStoryboard.main.instantiate() as DailyWeatherViewController
        controller.filteredData = filteredData
        return controller
    }
    
    private func createDataSource() {
        self.dataSource = [:]
        self.houlry.forEach { item in
            let date = Date(timeIntervalSince1970: item.dt).prettyTimesTamp
            if self.dataSource[date] == nil {
                self.dataSource[date] = [item]
            } else {
                var data = self.dataSource[date]
                data?.append(item)
                self.dataSource[date] = data
            }
        }
    }
    
    // MARK: - Custom Func
    private func weekdayNameFrom(weekdayNumber: Int) -> String {
        var calendar = Calendar.current
        let locale = Locale(identifier: "ka")
        calendar.locale = locale
        let dayIndex = ((weekdayNumber - 1) + (calendar.firstWeekday - 1)) % 7
        return calendar.weekdaySymbols[dayIndex]
    }
}

// MARK: - UITableViewDelegate && UITableViewDataSource
extension DailyWeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: DailyTableViewCell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifier, for: indexPath) as? DailyTableViewCell else {
            fatalError()
        }
        let dates = self.dataSource.keys.sorted()
        guard let hourly = self.dataSource[dates[indexPath.section]]?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.fillCell(with: hourly)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dates = self.dataSource.keys.sorted()
        return self.dataSource[dates[section]]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dates = self.dataSource.keys.sorted()
        let date = dates[section]
        let sectionTitle = self.weekdayNameFrom(weekdayNumber: date.weekdayOrdinal)
        return sectionTitle
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.count
    }
}

