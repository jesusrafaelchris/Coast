//
//  MessageLog.swift
//  KeyloopCarApp
//
//  Created by Christian Grinling on 09/02/2022.
//

import UIKit
import Firebase
import FirebaseFirestore
import Nuke

class MessageLog: UICollectionViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {


    let docRef = Firestore.firestore()
    var username: String?
    var garageid: String?
    var garagename: String?
    var messages = [messageInfo]()
    var latestmessage = [messageInfo]()
    var listener: ListenerRegistration?
    var listener2: ListenerRegistration?
    var Inputview: InputAccessoryView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardObservers()
        guard let cv = collectionView else {return}
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(cv)
        collectionView.alwaysBounceVertical = true
        observeMessages()
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.keyboardDismissMode = .interactive
        setupnavbar()
    }
    
    func setupnavbar() {
        let dismissbutton = UIBarButtonItem(image: UIImage(systemName: "multiply.circle.fill")?.withTintColor(.black).withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(dismisspage))
        self.navigationItem.rightBarButtonItem  = dismissbutton
        self.title = garagename
        
//        if #available(iOS 15, *) {
//                let appearance = UINavigationBarAppearance()
//                appearance.configureWithOpaqueBackground()
//                appearance.backgroundColor = UIColor(hexString: "222222")
//            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//                navigationController?.navigationBar.standardAppearance = appearance
//                navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
//            }
    }
    
    @objc func dismisspage() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func handleImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[.editedImage] as? UIImage{
            
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
           
            uploadImageToFirebase(selectedImage)
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadImageToFirebase(_ image: UIImage) {
        
        let imageName = NSUUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child(imageName)
        
        if let uploaddata = image.jpegData(compressionQuality: 1) {
            ref.putData(uploaddata, metadata: nil) { (metadata, error) in
                if error != nil{
                   // print(error?.localizedDescription as! String)
                    return
                }
                else {
            ref.downloadURL { (url, error) in
               if error != nil {
                //print(error?.localizedDescription as! String)
                return
               }
               guard let urlString = url?.absoluteString else{return}
                
                self.sendMessageWithImageUrl(urlString, image)
                    }
                }
            }
        }
    }
    
    private func sendMessageWithImageUrl(_ imageUrl: String,_ image: UIImage) {
        
        guard let fromID = Auth.auth().currentUser?.uid else {return}
        let timestamp = NSDate.timeIntervalSinceReferenceDate
        guard let toID = self.garageid else {return}
        
        let data = [
            "imageUrl": imageUrl,
            "TimeStamp": timestamp,
            "FromID": fromID as Any,
            "ToID": toID,
            "imageWidth": image.size.width ,
            "imageHeight": image.size.height ]
        

        let ref = Firestore.firestore().collection("user-messages").document(fromID).collection(toID)
            ref.addDocument(data: data)
            
        let recipientUserMessagesRef = Firestore.firestore().collection("user-messages").document(toID).collection(fromID)
        recipientUserMessagesRef.addDocument(data: data)
        
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputContainerView.Textbox.becomeFirstResponder()
    }
    
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
    }
    
    @objc func handleKeyboardDidShow() {
        if messages.count > 0 {
        DispatchQueue.main.async {
            let indexPath = NSIndexPath(item: self.messages.count - 1, section: 0)
            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let duration = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue)!

        containerViewbottomAnchor?.constant = -keyboardFrame!.height

        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let duration = ((notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue)!
         
         containerViewbottomAnchor?.constant = 0
         
        
         UIView.animate(withDuration: duration) {
             self.view.layoutIfNeeded()
         }
    }
    
    var containerViewbottomAnchor: NSLayoutConstraint?

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listener?.remove()
        listener2?.remove()
    }
    
    lazy var inputContainerView: InputAccessoryView = {
        let chatInputContainerView = InputAccessoryView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80))
        chatInputContainerView.messagelog = self
        return chatInputContainerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let toID = self.garageid else {return}
        let userMessagesRef = Firestore.firestore().collection("user-messages").document(uid).collection(toID).order(by: "TimeStamp", descending: false)
        
        listener = userMessagesRef.addSnapshotListener { (snapshot, error) in
        if let error = error {
                print(error.localizedDescription)
            }
        else {
            guard let documents = snapshot?.documents else {return}
            self.messages.removeAll()
            for document in documents {
                
                self.loadmessage(document: document)

            }
              DispatchQueue.main.async {
                self.collectionView.reloadData()
               if (self.collectionView.numberOfSections != 0) {
                   let lastIndexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView.scrollToItem(at: lastIndexPath, at: .bottom, animated: false)
                    }
                }
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if indexPath.row == 0 {
                print("Last cell")
            }
    }
    
    func loadmessage(document: QueryDocumentSnapshot) {
        guard let dictionary = document.data() as [String:AnyObject]? else {return}
        let message = messageInfo(dictionary: dictionary)
        self.messages.append(message)
    }
    
    @objc func sendMessage() {
        
        guard let text =  inputContainerView.Textbox.text else {return}
        guard let fromID = Auth.auth().currentUser?.uid else {return}
        let timestamp = NSDate.timeIntervalSinceReferenceDate
        guard let toID = self.garageid else {return}
        if text.isEmpty == true { }
        else {
            let data: [String : Any] =
                ["Text": text,
                "TimeStamp": timestamp,
                "FromID": fromID,
                "ToID": toID]

            inputContainerView.Textbox.text = ""

            
        let ref = Firestore.firestore().collection("user-messages").document(fromID).collection(toID)
            ref.addDocument(data: data)
                
        let recipientUserMessagesRef = Firestore.firestore().collection("user-messages").document(toID).collection(fromID)
            recipientUserMessagesRef.addDocument(data: data)
            
        let latestmessageRef1 = Firestore.firestore().collection("Latest-Messages").document(fromID).collection("Latest").document(toID)
            latestmessageRef1.setData(data)
        
        let latestmessageRef2 = Firestore.firestore().collection("Latest-Messages").document(toID).collection("Latest").document(fromID)
            latestmessageRef2.setData(data)

            DispatchQueue.main.async {
                self.collectionView.reloadData()
                }
            }
        }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImage: UIImageView?
    
    func performZoomForStartingImageView(_ startingImage: UIImageView) {

        self.startingImage = startingImage
        self.startingImage?.isHidden = true
        startingFrame = startingImage.superview?.convert(startingImage.frame, to: nil)
        
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImage.image
        zoomingImageView.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomOut))
        tapGestureRecognizer.numberOfTapsRequired = 1
        zoomingImageView.addGestureRecognizer(tapGestureRecognizer)
        inputContainerView.Textbox.resignFirstResponder()
        
        if let keyWindow = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.alpha = 0
            blackBackgroundView?.backgroundColor = .black
            
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(zoomingImageView)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackBackgroundView?.alpha = 1
            self.inputContainerView.alpha = 0
            
                let height = (self.startingFrame!.height / self.startingFrame!.width) * keyWindow.frame.width
                
            zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            
            zoomingImageView.center = keyWindow.center
                
            }, completion: nil)
  
        }
        
    }
    
    @objc func zoomOut(tap: UITapGestureRecognizer) {
        if let zoomOutImageView = tap.view {
            
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.clipsToBounds = true
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
                
            }) { (completed: Bool) in
                zoomOutImageView.removeFromSuperview()
                self.startingImage?.isHidden = false
                self.inputContainerView.Textbox.becomeFirstResponder()
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? ChatMessageCell {
        
            cell.MessageLog = self
            
            let message = messages[indexPath.item]
            cell.textView.text = message.Text
            
            //DispatchQueue.main.async {
            self.setUpCell(cell: cell, message: message)
            //}
            if let text = message.Text {
                //text
                cell.bubbleWidthAnchor?.constant = EstimatedFrame(text: text).width + 32
                cell.textView.isHidden = false
            } else if message.imageUrl != nil {
                // images go in here
                cell.bubbleWidthAnchor?.constant = 200
                cell.textView.isHidden = true

            }
            return cell
        }

            return UICollectionViewCell()
    }
    
    private func setUpCell(cell: ChatMessageCell, message: messageInfo) {
        guard let chatPartnerID = message.chatPartner() else {
            return
        }
        let ref = Firestore.firestore().collection("Garages").document(chatPartnerID)
        ref.getDocument { (snapshot, error) in
        if let error = error {
            print(error.localizedDescription)
        } else {
            if let snapshot = snapshot {
            let data = snapshot.data()
                let image = data?["Image"] as! String
                if let url = URL(string: image) {
                     Nuke.loadImage(with: url, into: cell.profileImageView)
                }
            }
        }
    }
        
        if message.FromID == Auth.auth().currentUser?.uid{
            //outgoing message
            cell.bubbleView.backgroundColor = UIColor(hexString: "222222")
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.bubbleViewRightAnchor?.isActive = true
        }
        else {
            // incoming message
            cell.bubbleView.backgroundColor = UIColor(hexString: "F6F6F6")
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
                
        if let messageUrl = message.imageUrl {
            guard let url = URL(string: messageUrl) else {return}
            Nuke.loadImage(with: url, into: cell.messageImageView)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        } else {
            cell.messageImageView.isHidden = true
            
            }
                }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }

}


extension MessageLog: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height:CGFloat = 80
        
        let message = messages[indexPath.item]
        
        if let text = message.Text {
            height = EstimatedFrame(text: text).height + 20
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
             height = CGFloat(imageHeight/imageWidth * 200)
        }

        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func EstimatedFrame(text:String) -> CGRect {
        
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}


