//
//  FemaleChatTableViewController.swift
//  ChatRoomPractice
//
//  Created by 羅以捷 on 2023/1/29.
//

import UIKit

class FemaleChatViewController: UIViewController {
    
    var chatRecords : [ChatRoomModel.Record] = []
    let name : String = "Female"
    var content : String = ""
    
    @IBOutlet weak var viewOfTextView: UIView!
    @IBOutlet weak var femaleChatTableView: UITableView!
    
    func addConstraints(){
        femaleChatTableView.translatesAutoresizingMaskIntoConstraints = false
        viewOfTextView.translatesAutoresizingMaskIntoConstraints = false
        femaleChatTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        femaleChatTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        femaleChatTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        femaleChatTableView.bottomAnchor.constraint(equalTo: viewOfTextView.topAnchor).isActive = true
        viewOfTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        viewOfTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        viewOfTextView.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor).isActive = true
        viewOfTextView.topAnchor.constraint(equalTo: femaleChatTableView.bottomAnchor).isActive = true

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
    
    @IBOutlet weak var contentButton: UIButton!
    
    @IBAction func contentButtonAction(_ sender: UIButton) {
        content = contentTextView.text
        guard !content.isEmpty else {return}
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
        chatRecords.insert(.init(fields: .init(name: name, content: content, sendTimeString: dateStr)), at: chatRecords.count)
        femaleChatTableView.insertRows(at: [[0,chatRecords.count-1]], with: .bottom)
        femaleChatTableView.scrollToRow(at: [0,chatRecords.count-1], at: .bottom, animated: true)
    }
    
    func updateUI(with chatRecord: [ChatRoomModel.Record]){
        DispatchQueue.main.async { [self] in
            chatRecords = chatRecord
            chatRecords.sort{  stringToDate($0.fields.sendTimeString) < stringToDate($1.fields.sendTimeString) }
            femaleChatTableView.reloadData()
            femaleChatTableView.scrollToRow(at: [0,chatRecords.count-1], at: .bottom, animated: false)
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
        femaleChatTableView.backgroundColor = .tertiaryLabel
//        femaleChatTableView.transform = CGAffineTransform(rotationAngle: .pi)
        addConstraints()
        super.viewDidLoad()
        
    }


}

extension FemaleChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRecords.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = chatRecords[indexPath.row].fields.name == name ? "femaleCellOfFemale" : "maleCellOfFemale"
        if identifier == "maleCellOfFemale" {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! MaleTableViewCell
            cell.backgroundColor = .clear
            cell.maleContent.layer.cornerRadius = 10
            cell.maleContent.layer.borderColor = UIColor.secondaryLabel.cgColor
            cell.maleContent.layer.masksToBounds = true
            cell.maleContent.layer.borderWidth = 1
            cell.maleContent.text = chatRecords[indexPath.row].fields.content
            cell.maleContent.backgroundColor = .white
//            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! FemaleTableViewCell
            cell.backgroundColor = .clear
            cell.femaleContent.text = chatRecords[indexPath.row].fields.content
            cell.femaleContent.layer.cornerRadius = 10
            cell.femaleContent.layer.borderColor = UIColor.secondaryLabel.cgColor
            cell.femaleContent.layer.masksToBounds = true
            cell.femaleContent.layer.borderWidth = 1
            cell.femaleContent.backgroundColor = .cyan
//            cell.transform = CGAffineTransform(rotationAngle: .pi)
            return cell
        }
    }
}


extension FemaleChatViewController : UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
            femaleChatTableView.scrollToRow(at: [0,chatRecords.count-1], at: .bottom, animated: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        femaleChatTableView.scrollToRow(at: [0,chatRecords.count-1], at: .bottom, animated: true)
        let height =  textView.contentSize.height
        textView.translatesAutoresizingMaskIntoConstraints = height >= 160
        textView.isScrollEnabled = height >= 160
    }
    
}
