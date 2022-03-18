//
//  TaskListViewController.swift
//  CoreData_demo
//
//  Created by User on 14.03.2022.
//

import UIKit

protocol TaskListViewControllerDelegate {
    func reloadData()
}

class TaskListViewController: UITableViewController {

    private let cellID = "task"
    private var taskList: [Task] {
        StorageManager.shared.taskList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
        StorageManager.shared.fetchData()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
          
        navigationController?.navigationBar.tintColor = .white
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // target - местоположение где этот метод будет реализовываться
        // action - то действие, которое будет выполнено при нажатии на кнопку
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    @objc private func addNewTask() {
        showAlert(with: "New task", and: "What do you want to do?")    }

    private func showAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _  in
            guard let task = alert.textFields?.first?.text, !task.isEmpty else { return }
            
            StorageManager.shared.save(task, in: self.tableView)
            self.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            textField.placeholder = "new task"
        }
        present(alert, animated: true)
    }
    
    private func showChangeAlert(with title: String, and message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newTask = alert.textFields?.first?.text else { return }
            guard let indexPath = self.tableView.indexPathForSelectedRow?.row else { return }
            
            StorageManager.shared.reSave(at: indexPath, and: newTask)
            self.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        alert.addTextField { textField in
            guard let indexPath = self.tableView.indexPathForSelectedRow?.row else { return }
            textField.text = self.taskList[indexPath].title
        }
        present(alert, animated: true)
    }
    
    private func reloadData() {
        StorageManager.shared.fetchData()
        tableView.reloadData()
    }
}

extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showChangeAlert(with: "Change task", and: "Enter new data, please.")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            StorageManager.shared.delete(at: indexPath.row)
            reloadData()
        }
    }
}
