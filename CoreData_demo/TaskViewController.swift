//
//  TaskViewController.swift
//  CoreData_demo
//
//  Created by User on 14.03.2022.
//

import UIKit
import CoreData



class TaskViewController: UIViewController {
    
    var delegate: TaskListViewControllerDelegate!

    //создаем временную область памяти - контекст
    //обращаемся к AppDelegate чтобы получить доступ к PersistentContainer и свойству ViewContext
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
     
    
    
    // lazy - будет вызван только когда к нему обратятся в первый раз
    private lazy var newTextField: UITextField  = {
        let textField = UITextField()
        textField.placeholder = "New task"
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private lazy var saveButton: UIButton = {
         let button = UIButton()
        button.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 1
        )
        button.setTitle("Save task", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        
        //target - где, action - какой метод вызывается, for - в какой момент должен быть вызван метод из action
        button.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
         let button = UIButton()
        button.backgroundColor = UIColor(
            red: 0.94,
            green: 0.35,
            blue: 0.19,
            alpha: 1
        )
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 4
        
        //target - где, action - какой метод вызывается, for - в какой момент должен быть вызван метод из action
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSubViews(newTextField, saveButton, cancelButton)
        setConstraints()
    }
    
    
    // Метод для размещения создаваемых элем.интерфейса на superview
    private func setupSubViews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    //Метод для установки констрейнов
    private func setConstraints() {
        newTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //Определяем якорь к чему хотим закрепить констрейн
            //equal - до куда устанавливаем констрейн
            newTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            newTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            newTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            saveButton.topAnchor.constraint(equalTo: newTextField.bottomAnchor , constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([

            cancelButton.topAnchor.constraint(equalTo: saveButton .bottomAnchor , constant: 20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
        
    }
    
    @objc private func save() {
        //создаем описание сущности
        //.entity  - возвращает сущность с указанным именем из модели связанной с координатором хранилища указанного контекста управляемого объекта
        //теперь контекст связан с координатором, а координатор связан с моделью данных, где производится поиск сущности по указанному имени.
        //созданный объект содержит в себе все настройки и параметры созданной сущности которые хранятся в редакторе модели данных(CoreData_demo)
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: context) else { return }
        // Создаем экземпляр модели NSManageObject на основе entityDescription и кастим до нужного типа
        // метод (entity:____, insertInto:_____) добавляет описание сущности в контекст
        guard let task = NSManagedObject(entity: entityDescription, insertInto: context) as? Task else { return }
        if newTextField.text != "" {
            task.title = newTextField.text
        }
        
        
        //Сейчас данные хранятся в контексте(оперативной памяти)
        
        //Переносим данные из контекста в persistent store, т.е сохраняем внесенные изменения.
        // Делаем проверку были ли изменения данных в контексе, если были то сохраняем (встроенный метод .save())
        if context.hasChanges {
            
            do {
                try context.save()
                
            } catch let error {
                print(error)
            }
        }
        
        delegate.reloadData()
        dismiss(animated: true)
    }
    
    @objc private func cancel() {
        dismiss(animated: true)
    }
}

