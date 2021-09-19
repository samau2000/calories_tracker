# calories_tracker

### Setup

### Introduction
In this calories tracker application, it will calculate calories of a recipe or food you eat by first use Gmail for authentication, scan the barcode of the ingredient, then ask for the user's amount of servings, and the user can keep track of all users recipes and daily food intake after adding the ingredients in either choice. To improve usability, we have used Flutter so that both Android and iOS users can have access to the application. 

### Front-End
On the Home page, we have three buttons: "Start barcode scan", "Find Recipes", and "Logout" after Gmail authentication. 

For "Start barcode scan" button, it links straight to barcode scanning and user can provide the ingredient's barcode to the camera. After scanning, the application will provide the ingredient's information and the number of calories per serving for the ingredient. The user can then select the number of servings for the ingredient. Additionally, there are two buttons: "Save to daily tracker" and "Add to recipe". After clicking on "Save to daily tracker", the ingredient will automatically bring user to daily's food intake page. After clicking on "Add to recipe", the application will allow user to choose the recipe that they want to add the ingredient to.

For "Find Recipes", the application will list the existing recipes that the user has saved initially. User can select the recipe they want to learn more about the specific ingredients. User can also add or delete recipes. 

### Back-End
This application has Google authentication integrated with it in order to let users sign in with their Google profiles and keep track of their dauly calories intake as well as their recipes. 

The database was setup up so that each user is able to save their daily intake and the recipes they create. It is structed into by having an endpoint for the daily intake and one for the recipes. The daily intake is then tracked by creating a entry consisting of the food item name and the calories that correspond to it based on the number of servings. The recipe endpoint is structured to save the name of the recipe and the ingredient that are requird for it. The ingredients are saved as individual entries that contain the name of the ingredient and the calories associated with it.

### Testing and Results
The application was tested by installing it on an android phone and extensively testing out all the functionalities by scanning different food items, adding items to the daily intake, creating recipes and adding ingredients to recipes. Prior to testing the app directly on the phone, we tested the FDA API by using Postman in order to determine the format in which the data was returned, and what the API expected in the request. 

### Demo

##### Gmail Authentication:
![3](https://user-images.githubusercontent.com/66945628/133844993-59b03c67-7fd6-41d7-b4b9-3e4efb4286c2.gif)

##### Scan Barcode and Add Ingredient to Recipe:
![2](https://user-images.githubusercontent.com/66945628/133844291-bc8dc281-5000-4444-ad22-f8c3429f2412.gif)

##### Scan Barcode and Add Ingredient to Daily Food Intake:
![1](https://user-images.githubusercontent.com/66945628/133844294-445e791a-5a35-4104-b08e-777a3a8d3e51.gif)

##### Find Recipes:
![4](https://user-images.githubusercontent.com/66945628/133844991-29a39abb-baf9-4158-8c65-0743c489044c.gif)
