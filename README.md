# README

* Ruby version: ruby 3.3.5

Description
A weather app that allows users to view current 7-day weather forecasts for various locations by entering a zip code.
This app saves user's weather data for quick access later and provides detailed temperature data for each day.

Features
- Search by zip code: Users can input a zip code to get the weather data for that location.
- 7-day forecast: Displays high and low temperatures for the next 7 days.
- Save locations: Users can save locations to view weather data quickly in the future.
- Update weather data: Updates weather info whenever the zip code changes.

Installation
1. Clone this repository: https://github.com/robeanobug/weather-app
2. Navigate to the project directory: cd weather-app
3. Install dependencies: bundle install
4. Set up the database:
rails db:create
rails db:migrate
5. Add an API key for the geocode data.
Go to https://geocode.xyz/api to make an account. Click get an API key. Create your account.
Generate an authentication code. Copy the code into a .env file located in the root directory.
This will make it so the application can find the Cartesian coordinates based of the zip codes entered by the user.
6. Run the server:
rails server
7. Open the app in your browser: http://localhost:3000

Future Improvements
- CSS: Add CSS other than the generic Simple CSS to make the application more appealing.
- Test code: The current test code is broken and needs fixing.
- Daily refresh: Update the weather forecase when the data is accessed on a new day so the forecast refreshes to the current day and does not display old data.
- User Authentication: Add functionality for users to create accounts, log in, and save their personal preferred locations.
- Improved Error Handling: Better handle API failures or incorrect zip codes with more descriptive error messages.
