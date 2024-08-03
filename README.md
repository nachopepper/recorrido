# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version 3.3.4

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

Antes de levantar el servidor, configurar la única variable de entorno que se ocupa que esta ubicada en el archivo .env.example

Paso a paso

* correr comando: bundle install
* correr comando: rails db:migrate
* corred comando: rails db:seed
* corred comando: rails server
  
Con esto queda corriend el servidor.
Para levantar la base de datos test

* correr comando: rails test:db

