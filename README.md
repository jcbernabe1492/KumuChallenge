# Kumu Coding Challenge

Coding Challenge as part of job application for iOS Developer

## Architecture

I used [Clean Swift](https://blog.devgenius.io/clean-swift-vip-with-example-6f6e643a1a01) architecture (a.k.a.VIP architecture).

The pattern is consisted of the following:
- Interactor - Prepares any parameters or events received from the View, then passes it to its Workers for execution or processing.
- Presenter - Presentation logic, prepares data before passing to the view.
- View - Receives any actions from the user. When an event is triggered calls the interactor if needed. Shows data or views received from the Presenter.
- Workers - Handles all networking, CoreData, Photos or any processing events.
- Router - I didn't use any since the application is simple. But technically this will be a programmatic implementation of a storyboard where relationship or flow of screens will be defined.
- Configurator (*Optional*) - Configures the relationship between the interactor, presenter and view.

## Classes

### `Interactors`

**MovieListInteractor.swift**

Responsible for fetching movies list. Called by the `ViewController` to trigger execution of backend requests. Communicates with a `RequestWorker` which in turn does all the networking work.

### `Worker`

**RequestWorker.swift**

Does all the networking work for the `Interactor`

**CoreDataWorker.swift**

Responsible for all CoreData related work. Manages all CRUD actions.

### `Presenter`

**MoviePresenter.swift**

Takes in all data from the `Interactor` then prepares it for presentation by the `View`.

Currently the only usage in the app is to prepare a view model that will be used by the `View`

Other use case can be to initialize an alert controller when receiving an error then just passing the created instance a `View` for presenting. Custom popup views is also a good example, initialize in the `Presenter` then present using a `View`

### `View`

Manages all data and views to be presented.

In this case, shows a list of movies using data contained in a view model generated by the `Presenter`.

Since the app is small a `Router` class was not used anymore, instead just directly presents a Detail view controller whenever the user selects a movie.

### `Configurator`

**Configurator.swift**

This is optional, since the contents of this class can also be done in the implementing app if the project is created as a framework. Or inside the ViewController ```init()``` function

## Development setup

**Dependencies**

[SnapKit](https://github.com/SnapKit/SnapKit) is used to help with programmatically creating views. 


## Meta

John Christopher Bernabe – jcbernabe1492@gmail.com

[https://github.com/jcbernabe1492/KumuChallenge/tree/master/KumuChallenge](https://github.com/jcbernabe1492/KumuChallenge/tree/master/KumuChallenge)
