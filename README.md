# <div align="center">  Whether, Sweater?

<p align="center">
  <img src="https://user-images.githubusercontent.com/67389821/109677726-ca704700-7b2e-11eb-8688-052e09d825a7.png" alt="sweaters" width="200"/> </img>
</p>

## Description
Whether, Sweater? is an API based application, developed to help plan a road trip with weather and restaurant information. This API consumes 4 other public APIs in addition to implementing user management features.
- [Schema](#schema)
- [Technology](#technology)
- [Achievements](#achievements)
- [Instructions](#instructions)
- [Design Strategy](#design-strategy)
- [Future Functionality](#future-functionality)
- [Contributors](#contributors)
- [Acknowledgements](#acknowledgements)

## Schema
![Schema](https://user-images.githubusercontent.com/67389821/107423165-e143f080-6ad0-11eb-8d79-9875185b18d1.png)

## Technology
   ![](https://img.shields.io/badge/Rails-5.2.4-informational?style=flat&logo=<LOGO_NAME>&logoColor=white&color=2bbc8a) [![Build Status](https://travis-ci.com/ninesky00/viewing_party.svg?branch=main)](https://travis-ci.com/ninesky00/viewing_party)

## Instructions
This application is hosted on [Heroku](https://what-the-weather-cyd.herokuapp.com/), where you'll be able to view its functionality to the fullest.

For usage on your local machine follow the instructions listed below:
```
git clone git@github.com:cowens87/whether_sweater.git
cd whether_sweater
bundle install
rails db:{drop,create,migrate,seed}
```

This is the base repo for the [sweater weather project](https://backend.turing.io/module3/projects/sweater_weather/) used for Turing's Backend Module 3.

## Design Strategy
The design strategy of Whether, Sweater? was to fully encapsulate each piece of functionality of the program and minimally store data, while avoiding API consumption limits:

### Users Table
- The Users Table represents all registered users for the Whether, Sweater? application. Users are represented in the application as the current user and can also be represented as a friend of another registered user.

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
## Future Functionality
- Allow users to include a message or link when a new party is created.
- Include movie poster on both the discover and movie details page.
- Include a token in the email

## Contributing

Contributions are what make this community such an amazing and fun place to learn, grow, and create! Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch ```git checkout -b feature/NewGreatFeature```
3. Commit your Changes ```git commit -m 'Add some NewGreatFeature'```
4. Push to the Branch ```git push origin feature/NewGreatFeature```
5. Open a new Pull Request!


## Contact

Cydnee Owens - [LinkedIn](https://www.linkedin.com/in/cydnee-owens-683a3450/) | [GitHub](https://github.com/cowens87)

## Acknowledgements
[The Movie Database](https://developers.themoviedb.org/3/getting-started/introduction)
