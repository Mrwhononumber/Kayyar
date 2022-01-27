//
//  detailViewController.swift
//  mapKitPractice
//
//  Created by Basem El kady on 10/25/21.
//

import UIKit
import MapKit




class SpotDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var reviewTableview: UITableView!
    @IBOutlet weak var myCollectionView: UICollectionView!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var spotKayyarLevelLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var spotAuthorUsername: UILabel!
    
    var detailSpot: Spot!
    let reviews = Reviews()
    let photos = Photos()
    private var userName: String?
    
    
    //MARK: - ViewController Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupMyCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
        showActivityIndicator()
        fetchReviews()
        fetchPhotos()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        removeActivityIndicator()
    }
    
    //MARK: - Buttons Actions
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        showImagePickerAlert()
    }
    
    //MARK: - Helper Methods
    
    private func updateUI(){
        addressLabel.text = detailSpot.address
        spotKayyarLevelLabel.text = "Kayyar: \(String(detailSpot.dangerLevel))"
        spotAuthorUsername.text = "By @\(detailSpot.spotUsername)"
        setupDetailMaViewMap()
        title = detailSpot.city
        CustomUI.setupButtonsShadow(button: cameraButton)
        CustomUI.setupButtonsShadow(button: reviewButton)
        updateUsername()
    }
    
    private func fetchReviews() {
        reviews.loadReviewData(spot: detailSpot) { [weak self] in
            guard let self = self else {return}
            self.reviewTableview.reloadData()
        }
    }
    
    private func fetchPhotos(){
        photos.loadPhotoData(spot: detailSpot) { [weak self] in
            guard let self = self else {return}
            self.myCollectionView.reloadData()
        }
    }
    
    private func updateUsername(){
        getCurrentUsername{ [weak self] name in
            guard let self = self else {return}
            self.userName = name
        }
    }
    
    //MARK: - DetailView Map setup
    
    private func setupDetailMaViewMap(){
        
        let mySpotLocation = CLLocationCoordinate2D(latitude: detailSpot.latitude, longitude: detailSpot.longitude)
        let myRegion = MKCoordinateRegion(center: mySpotLocation, latitudinalMeters: 650, longitudinalMeters: 650)
        detailMapView.setRegion(myRegion, animated: true)
        // Add Pin
        let pin = MKPointAnnotation()
        pin.coordinate = mySpotLocation
        pin.title = detailSpot.kayyarMessage
        pin.subtitle = detailSpot.address
        detailMapView.addAnnotation(pin)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ReviewViewController
        destination.spot = detailSpot
    }
    
    
}

//MARK: - TableView Datasource and Delegate

extension SpotDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func setupTableView(){
        reviewTableview.delegate = self
        reviewTableview.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.reviewArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableview.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewTableViewCell
        cell.review = reviews.reviewArray[indexPath.row]
        return cell
    }
    
}

//MARK: - ImagePicker

extension SpotDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func showImagePickerAlert(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] action in
            guard let self = self else {return}
            // setup image picker using camera
            self.setupImagePicker(type: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo library", style: .default, handler: { [weak self] action in
            guard let self = self else {return}
            // setup image picker using library
            self.setupImagePicker(type: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    }
    
    private func setupImagePicker(type: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var myImage: UIImage?
        // pass the taken picture to myImage to be uploaded to Firestore
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            myImage = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            myImage = originalImage
        }
        // save the myImage to FireStore
        let photo = Photo()
        photo.photoUsername = userName ?? ""
        photo.photoDate = getCurrentDateAndTimeString()
        photo.image = myImage ?? UIImage()
        photo.savePhotoData(spot: detailSpot) { [weak self] success in
            guard let self = self else {return}
            if success {
                print ("success")
            } else {
                self.myOneButtonAlert(title: "Error", message: "Error happened while saving the picture, please try again")
                print ("check whats going on with the savephoto method at the call site")
            }
        }
        // dismiss the imagePicker
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - CollectionView DataSource and Delegate

extension SpotDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    private func setupMyCollectionView(){
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if photos.photoArray.count > 0 {
            return photos.photoArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! MyCollectionViewCell
        cell.spot = detailSpot
        if photos.photoArray.count > 0 {
            cell.photo = photos.photoArray[indexPath.row]
        }
        return cell
    }
    
}


