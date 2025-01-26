Discover Kenya API
This is the Discover Kenya API, a service designed to manage and interact with tourist attractions, users, and authentication for the platform. The API allows users to register, log in, search, create, approve, reject, and log out from the system.

Table of Contents
Installation
Authentication
Endpoints
User Registration
User Login
Search Attractions
Post Attraction
Approve Attraction
Reject Attraction
Logout
Error Handling
Installation

Any REST client (e.g., Postman or Insomnia)
Setup
Clone the repository:


git clone https://github.com/ndush/Discover-Kenya-Api.git
cd Discover-Kenya-Api
Install dependencies:



Set up environment variables for the database connection and any other required configurations.

Start the server:


Your server will now be running at http://localhost:3000.

Authentication
To interact with most endpoints, users need to be authenticated.

User Registration
To create a new user, make a POST request to /users/register.

Request Body:
json

{
  "email": "sam@mail.com",
  "password": "yourPassword",
  "name": "Sam"
}
Response:
json

{
  "user": {
    "id": 18,
    "email": "sam@mail.com",
    "role": "user",
    "created_at": "2025-01-26T19:59:00.797Z",
    "updated_at": "2025-01-26T19:59:00.797Z"
  },
  "token": "cba4e61a6fb7047011c05a61a3a73dcf2b259d88"
}
The response includes a JWT token used for authentication.

User Login
To log in, make a POST request to /users/login.

Request Body:
json

{
  "email": "sam@mail.com",
  "password": "yourPassword"
}
Response:
json

{
  "message": "Logged in successfully",
  "session_token": "3:ed9e578e43f5165dfe02232bea2774403348a1..."
}
The session token is used for further authentication on other routes.

User Logout
To log out, make a POST request to /users/logout.

Response:


{
  "message": "Logged out successfully"
}
The session token is invalidated upon logging out.

Endpoints
1. User Registration
URL: POST /users/register

Description: Creates a new user.

Response:

201 Created
json

{
  "user": { ... },
  "token": "jwt-token"
}
2. User Login
URL: POST /users/login

Description: Logs the user in and returns a session token.

Response:

200 OK
json

{
  "message": "Logged in successfully",
  "session_token": "jwt-token"
}
3. Search Attractions
URL: GET /attractions/search

Description: Searches for attractions by name, category, and location.

Query Parameters:
name: Name of the attraction (e.g., "mount elgon")
latitude: Latitude of the search location
longitude: Longitude of the search location
radius: Search radius (in meters)
category: Category of the attraction
price: Price range for the attraction
Response:

200 OK
json

[
  {
    "name": "Mount Elgon Hospital",
    "address": "Mount Elgon Hospital, Trans Nzoia, Kenya",
    "id": "here:pds:place:404jx7ps"
  },
  ...
]
4. Post Attraction
URL: POST /attractions

Description: Creates a new attraction.

Request Body:
json

{
  "name": "Pinnacleo0",
  "description": "A beautiful place to visit in Limurun.",
  "country": "Kenya",
  "price": "2009"
}
Response:

201 Created
json

{
  "id": 20,
  "name": "Pinnacleo0",
  "description": "A beautiful place to visit in Limurun.",
  "country": "Kenya",
  "price": "2009"
}
5. Approve Attraction
URL: POST /attractions/:id/approve

Description: Approves a pending attraction.

Response:

200 OK
json

{
  "status": "approved",
  "name": "Pinnacleo0",
  "description": "A beautiful place to visit in Limurun.",
  "price": "2009"
}
6. Reject Attraction
URL: POST /attractions/:id/reject

Description: Rejects a pending attraction.

Response:

200 OK
json

{
  "status": "rejected",
  "name": "Pinnacleo0",
  "description": "A beautiful place to visit in Limurun.",
  "price": "2009"
}
7. Logout
URL: POST /users/logout

Description: Logs the user out of the system.

Response:

200 OK
json

{
  "message": "Logged out successfully"
}
