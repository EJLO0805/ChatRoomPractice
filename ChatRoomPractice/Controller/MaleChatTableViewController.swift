//
//  MaleChatTableViewController.swift
//  ChatRoomPractice
//
//  Created by 羅以捷 on 2023/1/29.
//

import UIKit

class MaleChatViewController: UIViewController {
    
    var chatRecords : [ChatRoomModel.Record] = []
    let name : String = "Male"
    var content : String = ""
    @IBOutlet weak var maleChatTableView: UITableView!
    @IBOutlet weak var viewOfTextView: UIView!
    
    func addConstraints(){
        maleChatTableView.translatesAutoresizingMaskIntoConstraints = false
        viewOfTextView.translatesAutoresizingMaskIntoConstraints = false
        maleChatTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        maleChatTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        maleChatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        maleChatTableView.bottomAnchor.constraint(equalTo: viewOfTextView.topAnchor).isActive = true
        viewOfTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        viewOfTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        viewOfTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        viewOfTextView.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 200).isActive = true

    }
    
    @IBAction func closeKeyBoard(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBOutlet weak var contentTextView: UITextView!{
        didSet{
            contentTextView.layer.masksToBounds = true
            contentTextView.layer.cornerRadius = 10
            contentTextView.layer.borderWidth = 1
            contentTextView.layer.borderColor = UIColor.secondaryLabel.cgColor
            contentTextView.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        }
    }
    
    @IBOutlet weak var enterButton: UIButton!
    
    @IBAction func enterButtonAction(_ sender: UIButton) {
        content = contentTextView.text
        guard !content.isEmpty else { return }
        let contentModel = ChatContentModel(name: name, content: content)
        FetchData.uploadChatContent(chatContent: contentModel) { result in
            switch result {
                case .success(_):
                    print("成功")
                case .failure(let error):
                    print(error)
            }
        }
        contentTextView.text = ""
        let dateStr = dateToString(Date.now)
        chatRecords.insert(.init(fields: .init(name: name, content: content, sendTimeString: dateStr)), at: 0)
        maleChatTableView.insertRows(at: [[0,0]], with: .top)
        
    }
    
    func updateUI(with chatRecord: [ChatRoomModel.Record]){
        DispatchQueue.main.async { [self] in
            chatRecords = chatRecord
            chatRecords.sort{  stringToDate($0.fields.sendTimeString) > stringToDate($1.fields.sendTimeString) }
            maleChatTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FetchData.fetchChatContent { result in
            switch result{
                case .success(let chatRecords):
                    self.updateUI(with: chatRecords)
                case .failure(let error):
                    print(error)
            }
        }
    }
    
    override func viewDidLoad() {
        FetchData.fetchChatContent { result in
            switch result {
                case .success(let records):
                    self.updateUI(with: records)
                case .failure(let error):
                    print(error)
            }
        }
        contentTextView.delegate = self
        maleChatTableView.backgroundColor = .tertiaryLabel
        maleChatTableView.transform = CGAffineTransform(rotationAngle: .pi)
        addConstraints()
        super.viewDidLoad()
    }

}

extension MaleChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = chatRecords[indexPath.row].fields.name == name ? "maleCellOfMale" : "femaleCellOfMale"
        if identifier == "maleCellOfMale" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MaleTableViewCell
            cell.backgroundColor = .clear
            cell.maleContent.text = chatRecords[indexPath.row].fields.content
            cell.maleContent.layer.cornerRadius = 10
            cell.maleContent.layer.borderColor = UIColor.secondaryLabel.cgColor
            cell.maleContent.layer.masksToBounds = true
            cell.maleContent.layer.borderWidth = 1
            cell.maleContent.backgroundColor = .cyan
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FemaleTableViewCell
            cell.backgroundColor = .clear
            cell.femaleContent.text = chatRecords[indexPath.row].fields.content
            cell.femaleContent.layer.cornerRadius = 10
            cell.femaleContent.layer.borderColor = UIColor.secondaryLabel.cgColor
            cell.femaleContent.layer.borderWidth = 1
            cell.femaleContent.layer.masksToBounds = true
            cell.femaleContent.backgroundColor = .white
            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        }
    }
    
}


extension MaleChatViewController : UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        let height =  textView.contentSize.height
        textView.translatesAutoresizingMaskIntoConstraints = height >= 160
        textView.isScrollEnabled = height >= 160
    }
    
}

