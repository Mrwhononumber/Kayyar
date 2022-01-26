# Kayyar - Share the dangerous spots around you! 
Simple iOS application in Swift demonstrating the usage of Multible technologies and frameworks

<img src="https://github.com/Mrwhononumber/Images/blob/b1c0bf7d44355244621cabf48377a9ca8b7bfddb/Kayyar/Simulator%20Screen%20Shot%20-%20iPhone%2011%20-%202022-01-26%20at%2016.41.45.png" width="200">



# Application Features

* Easily choose the spot you'd like to share on the map

* View the spots shared by other users

* Sort the spots shared by users based on (proximitie - recently - danger score)

* Rate the danger score of each spot

* Add comments to the the spots

* upload pictures to each spot using your camera or photos library 

# Implementation features


* Used architecture is MVC

* UI has been built using StoryBoards

* Firestore is used for user authentication

* getting the user's choosen address has been done using mapKit and reverse geolocating

* the database used is firestore

* Images downloading and caching happen via SDWebImage


# Improvements in progress 

* Create a location manager singleton class to have one unified point to the user's location within the app

* redesign the viewcontroller responsible for adding newcomment/rating 
