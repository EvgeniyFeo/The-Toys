//
//  UserViewController.swift
//  The Toys
//
//  Created by Eugene Feoktistov on 7/20/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UserViewController: TemplateViewController {
    
    //    MARK: - Variables -
    
    let profileImagePlaceholder: UIImage = UIImage(systemName: "person.circle") ?? UIImage()
    private var avatarImageSize: CGSize = CGSize(width: 150, height: 150)
    private var userData = UserData()
    
    private lazy var userAvatar: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = self.userData.avatar ?? self.profileImagePlaceholder
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = self.avatarImageSize.height / 2
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImagePicker)))
        
        return imageView
    }()
    
    private lazy var userName: TemplateLabel = {
        let label = TemplateLabel()
        
        label.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        label.numberOfLines = 3
//        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.75
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var userEmail: TemplateLabel = {
        let label = TemplateLabel()
        
//        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var fillProfileButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Заполнить профиль", for: .normal)
        button.addTarget(self, action: #selector(fillProfileDidTap), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var signOutButton: TemplateButton = {
        let button = TemplateButton()
        
        button.setTitle("Выйти из профиля", for: .normal)
        button.addTarget(self, action: #selector(signOutDidTap), for: .touchUpInside)
        
        return button
    }()
    
    //    MARK: -  ViewContoller LifeCicle -
    
    override func loadView() {
        super.loadView()
        
        self.addSubviews()
        self.setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getUserData()
        self.setUserData()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
    }
    
    //    MARK: - Set ViewContoller -
    
    private func addSubviews() {
        
        self.view.addSubview(signOutButton)
        self.view.addSubview(userAvatar)
        self.view.addSubview(userName)
        self.view.addSubview(userEmail)
        self.view.addSubview(fillProfileButton)
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate(
            [
                self.signOutButton.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 15),
                self.signOutButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8),
                self.signOutButton.widthAnchor.constraint(equalToConstant: 175),
                
                self.userAvatar.heightAnchor.constraint(equalToConstant: 150),
                self.userAvatar.widthAnchor.constraint(equalTo: self.userAvatar.heightAnchor),
                self.userAvatar.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -50),
                self.userAvatar.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                
                self.userName.topAnchor.constraint(equalTo: self.userAvatar.bottomAnchor, constant: 20),
                self.userName.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.userName.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                
                self.userEmail.topAnchor.constraint(equalTo: self.userName.bottomAnchor, constant: 10),
                self.userEmail.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                self.userEmail.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
                
                self.fillProfileButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50),
                self.fillProfileButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                self.fillProfileButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            ]
        )
    }
    
    private func setUserData() {
        
        self.userEmail.text = self.userData.email
        self.userName.text = self.userData.name
    }
    
    private func getUserData() {
        
        guard let user = Auth.auth().currentUser else { return }
        
        let storageReference = Storage.storage().reference().child("users/\(user.uid)")
        self.userData.name = user.displayName ?? ""
        self.userName.text = user.displayName
        self.userData.email = user.email ?? ""
        
        storageReference.getMetadata { (metadata: StorageMetadata?, error) in
            if let error = error {
                Swift.debugPrint(error.localizedDescription)
            } else {
                guard let metadata = metadata else {
                    self.userAvatar.image = self.profileImagePlaceholder
                    return
                }
                
                if metadata.isFile {
                    self.userAvatar.sd_setImage(with: storageReference)
                } else {
                    self.userAvatar.image = self.profileImagePlaceholder
                }
            }
        }
    }
    
    //    MARK: - Actions -
    
    @objc func openImagePicker() {
        
        let alert = UIAlertController(title: "Выберите изображение профиля", message: nil, preferredStyle: .actionSheet)
        
        let galleryAction = UIAlertAction(title: "Открыть галерею", style: .default) { UIAlertAction in
            let picker = UIImagePickerController()
            picker.mediaTypes = ["public.image"]
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Сделать фото", style: .default) { UIAlertAction in
            let picker = UIImagePickerController()
            picker.mediaTypes = ["public.image"]
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            
            self.present(picker, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func fillProfileDidTap() {
        
        let fillUserDataController = FillUserDataViewController()
        self.navigationController?.pushViewController(fillUserDataController, animated: true)
    }
    
    @objc private func signOutDidTap() {
        
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}

//    MARK: -  ViewContoller Extensions -

extension UserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        guard let user = Auth.auth().currentUser,
              let image = info[.editedImage] as? UIImage,
              let data = image.jpegData(compressionQuality: 0.5) else {
            self.userAvatar.image = info[.originalImage] as? UIImage
            return
        }
        
        let metadata = StorageMetadata()
        
        let storageReference = Storage.storage().reference().child("users/\(user.uid)")
        storageReference.putData(data, metadata: metadata) { (metadata, error) in
            if error == nil {
                storageReference.downloadURL { (url, error) in
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.photoURL = url
                    changeRequest.commitChanges { (error) in
                        if let error = error {
                            self.showAlert(title: "Загрузка", message: error.localizedDescription)
                        } else {
                            Swift.debugPrint("Изображение загружено, Url: \(String(describing: url))")
                        }
                    }
                }
            } else {
                Swift.debugPrint("Ошибка \(String(describing: error))")
            }
        }
        
        self.userAvatar.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

