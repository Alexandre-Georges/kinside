# README

## Setup

```bash
rake db:migrate
```

I made just one migration to create the DB and have the integrity constraints in place.

## Run the project

### Start the server

```bash
rails s
```

### Initialization of the DB

[Go there to trigger the initialization of the DB.](http://localhost:3000/init)

This part was designed to be somewhat resilient against inconsistent data, we have a few cases where an actor ID in a movie does not exist in the actor data.

Integrity constraints help a lot with this kind of setup. That being said we never know how good or bad the data can be. Overall I would suggest having a process in place that will insert the data that is correct and report the incorrect data so we can act on it or ignore the error if there is nothing we can do about it.

## Endpoints

### Movies

[Movies data](http://localhost:3000/movies?ids[]=1&ids[]=2)

### Actors

[Actor data](http://localhost:3000/actors?ids[]=c4eb4ebe-96b8-4a1b-a74f-c2bd3e8f4cf4&ids[]=47c40d96-9486-42ca-bdbd-2c0ea2fc0bb1)

## Where to go from there

### Validation and API contract

I took a few shortcuts in this project: the code is directly in the controller and there is no validation of the parameters. An API contract should be defined so everyone is on the same page regarding how the API behaves. This is especially valid for edge cases (no movie ID provided for example).

### Active Record vs SQL

I tried to use Active Record for the DB but I ended up in a situation where there would be no integrity constraints. This is less than ideal. I also ran into issues with many to many associations that would not work correctly when the primary key is a string.

To solve those issues I decided to switch to pure SQL. In the case of an API the data integrity is crucial and I could not get what I wanted with Active Record. It might be possible to have the same result with Active Record but I find the documentation unclear and limited. I cut the middle-man to get the job done.

### Endpoints

I decided to use GET requests for my endpoints, this is debatable. Having POST requests would be better so the client can specify as many IDs as it wants. I picked that implementation as it is easier to run and QA for this specific challenge. For a real application POST would be a better choice.

Alos, it would be necessary to have a mechanism in place to identify the client and make sure it is allowed to call endpoints.
