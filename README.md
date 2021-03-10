# <div align="center">  Whether, Sweater?

<p align="center">
  <img src="https://user-images.githubusercontent.com/67389821/109677726-ca704700-7b2e-11eb-8688-052e09d825a7.png" alt="sweaters" width="200"/> </img>
</p>

## Description
Whether, Sweater? is an API based application, developed to help plan a road trip with weather information. This API consumes 4 other public APIs in addition to implementing user management features.
- [Schema](#schema)
- [Technology](#technology)
- [Achievements](#achievements)
- [Instructions](#instructions)
- [Design Strategy](#design-strategy)
- [Endpoints](#endpoints)
- [Future Functionality](#future-functionality)
- [Contributors](#contributors)
- [Acknowledgements](#acknowledgements)

## Schema
![Schema](https://user-images.githubusercontent.com/67389821/110380385-e2ebd000-800c-11eb-8b4a-6dd3ab274671.png)

## Technology
   ![](https://img.shields.io/badge/Rails-5.2.4-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a) 

## Instructions
This application is hosted on [Heroku](https://what-the-weather-cyd.herokuapp.com/), where you'll be able to view its functionality to the fullest.

For usage on your local machine follow the instructions listed below:
* Setup Database
```
$ git clone git@github.com:cowens87/whether_sweater.git
$ cd whether_sweater
$ bundle install
$ rails db:{create,migrate}
```
* Sign-Up for API Keys
  * [OpenWeather](https://openweathermap.org/api/one-call-api)
  * [MapQuest](https://developer.mapquest.com/documentation/)
  * [Unsplash](https://unsplash.com/documentation)
  * [Yelp](https://www.yelp.com/developers/v3/manage_app)

* Set up API access
```
$ figaro install
```
In your `config/application.yml` file, input your API keys
```
WEATHER_API_KEY: "<Your OpenWeather API Key>"
MAP_API_KEY: "<Your MapQuest API Key>"
IMAGE_API_KEY: "<Your Unsplash API Key>"
YELP_API_KEY: "Bearer <Your Yelp API Key>"
```
This is the base repo for the [sweater weather project](https://backend.turing.io/module3/projects/sweater_weather/) used for Turing's Backend Module 3.

## Design Strategy
The design strategy of Whether, Sweater? was to fully encapsulate each piece of functionality of the program and minimally store data, while avoiding API consumption limits. 

## API Endpoints
The following endpoints were implemented in this project:

#### Forecast Endpoint
This forecast endpoint retrieves the weather for a city when given a `location` parameter.

`GET /api/v1/forecast?location=mountainview,ca`

Example JSON response:
```json
{
  "data": {
    "id": null,
    "type": "forecast",
    "attributes": {
        "current_weather": {
          "datetime": "2021-03-08T12:52:29.000-08:00",
          "sunrise": "2021-03-08T06:29:16.000-08:00",
          "sunset": "2021-03-08T18:09:00.000-08:00",
          "temperature": 58.35,
          "feels_like": 52.11,
          "humidity": 36,
          "uvi": 4.25,
          "visibility": 10000,
          "conditions": "scattered clouds",
          "icon": "03d"
      },
        "daily_weather": [{
          "date": "2021-03-08",
          "sunrise": "2021-03-08T06:29:16.000-08:00",
          "sunset": "2021-03-08T18:09:00.000-08:00",
          "max_temp": 58.35,
          "min_temp": 45.82,
          "conditions": "scattered clouds",
          "icon": "03d"
        },
          // ... the next 4 days of daily data
      ],
        "hourly_weather": [{
          "time": "12:00:00",
          "temperature": 58.35,
          "conditions": "scattered clouds",
          "icon": "03d"
        },
          // ... the next 7 hours of hourly data
      ]
    }
  }
}
```
#### Backgrounds

This backgrounds endpoint retrieves a background photo for a city when given a `location` parameter.

`GET /api/v1/backgrounds?location=mountainview,ca`

Example JSON response:
```json
{
    "data": {
        "id": null,
        "type": "image",
        "attributes": {
            "image": {
                "location": "Sacramento, CA",
                "image_url": "https://images.unsplash.com/photo-1584259432764-863c1d73f22d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MXwyMTI3MjF8MHwxfHNlYXJjaHwxfHxTYWNyYW1lbnRvLCUyMENBfGVufDF8MHx8&ixlib=rb-1.2.1&q=80&w=1080",
                "credit": {
                    "source": "https://unsplash.com/",
                    "author": "Meritt Thomas",
                    "logo": "https://unsplash.com/@merittthomas"
                }
            }
        }
    }
}
```
#### User Registration

This endpoint creates a user and renders a JSON representation of the new user.

`POST /api/v1/users`

The body of the post request is a JSON payload:
```json
{
  "email": "someone@example.com",
  "password": "password",
  "password_confirmation": "password"
}
```

Example JSON response:
```json
{
  "data": {
    "type": "user",
    "id": "1",
    "attributes": {
      "email": "someone@example.com",
      "api_key": "jgn983hy48thw9begh98h4539h4"
    }
  }
}
```
#### User Authentication

This endpoint authenticates an existing user and renders a JSON representation of the existing user.

```
POST /api/v1/sessions
```
The body of the post request is a JSON payload:
```json
{
  "email": "someone@example.com",
  "password": "password"
}
```

Example JSON response:
```json
{
  "data": {
    "type": "user",
    "id": "1",
    "attributes": {
      "email": "someone@example.com",
      "api_key": "jgn983hy48thw9begh98h4539h4"
    }
  }
}
```
#### Road Trip

This road trip endpoint retrieves travel time and weather for a destination. This endpoint restricts access to users via authentication by their api key.

`POST /api/v1/road_trip`

The body of the post request is a JSON payload:
```json
{
  "origin": "Mountain View, CA",
  "destination": "San Diego, CA",
  "api_key": "qtuihj1y48thw9begh98h4539h4"
}
```

Example JSON response:
```json
{
  "data": {
    "id": null,
    "type": "road_trip",
    "attributes": {
      "start_city": "Mountain View, CA",
      "end_city": "San Diego, CA",
      "travel_time": "7 hours, 15 minutes",
      "weather_at_eta": {
        "temperature": 68.2,
        "conditions": "it's raining sloths and elephants"
      }
    }
  }
}
```
### Users Table
- The Users Table represents all authenticated users for Whether, Sweater? application.

## Achievements
- Continuous deployment to Heroku.
- Utilized TDD to ensure comprehensive application functionality, including both 'happy' and 'sad' paths.
- Exposed API that both aggregated data from multiple external APIs and that required an authentication token
- Routing is organized and consistent and demonstrates use RESTful principles.
- All User Stories 100% complete including edge cases.
- 100% test coverage for all request, facades, PORO and services.
- Tests are well written and meaningful.
- Clear schema design with detailed and accurate diagram.
- Project completed within seven-day time frame.
- Added functionality via multiple API endpoints to create a dynamic user experience.
- Authenticated user login via sessions implementation.  

## Contributing

Contributions are what make this community such an amazing and fun place to learn, grow, and create! Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch ```git checkout -b feature/NewFeature```
3. Commit your Changes ```git commit -m 'Add some NewFeature'```
4. Push to the Branch ```git push origin feature/NewFeature```
5. Open a new Pull Request!

## Contact

Cydnee Owens - [LinkedIn](https://www.linkedin.com/in/cydnee-owens-683a3450/) | [GitHub](https://github.com/cowens87)

## Acknowledgements
- [Open Weather API](https://openweathermap.org/api)
- [MapQuest API](https://developer.mapquest.com/documentation/directions-api/route/get/)
- [Unsplash API](https://unsplash.com/developers)
- [Yelp API](https://www.yelp.com/developers/documentation/v3/business_search)
