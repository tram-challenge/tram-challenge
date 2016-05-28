# Tram Challenge API

**Endpoint:** `https://tramchallenge.com`

Include the `icloud_user_id` param with each request.

* Start an attempt: make a `POST` request to `/api/attempts`

  The JSON response will return the attempt with a list of stops that need to be visited.

* Get the attempt data: make a `GET` request to `/api/attempt/:attempt_id` (a link to self is also included in the JSON response).

* Mark a stop as visited: make a PUT request to `/api/stops/:stop_id` (a link to each stop is included in the attempt JSON response) with the following JSON body:

  ```json
  {
    "stop": {
      "visited": true
    }
  }
  ```

* Mark a stop as unvisited: make a PUT request to `/api/stops/:stop_id` with the following JSON body:

  ```json
  {
    "stop": {
      "visited": false
    }
  }
  ```
