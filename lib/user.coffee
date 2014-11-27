'use strict'

# *Modules*
request     = require 'request'
Q           = require 'q'
LocalDB     = require 'localdb'
chalk       = require 'chalk'
_           = require 'underscore'

# *Class*


class User

  constructor: (user) ->
    # Create new instance of User Class.
    if not (@ instanceof User)

      # This will return object {}
      return new User(user)

    # Set
    @user       = user
    @page       = 1
    @per_page   = 50
    @total      = 0
    @received   = 0
    @db         = new LocalDB('Manifest', process.cwd())


  exec: =>
    Q.fcall(->)
    .then(@getUserVideos)
    .then(@getVideoIdArray)
    .then(@create)
    .then(@checkTotalData)
    .fail(@exec)


  create: (params) =>
    console.log chalk.blue("adding item to queue...")
    deferred = Q.defer()
    @db.create params, (error, results) ->

      if error
        deferred.reject error
      else
        deferred.resolve results
    deferred.promise

  getUserVideos: =>
    options = @getOptions()
    console.log ''
    console.log chalk.magenta('---------------------------')
    console.log ''
    console.log chalk.blue("reading : #{options.url}")
    deferred = Q.defer()
    request @getOptions(), (error, response, body) =>
      json = JSON.parse body

      # Update info
      @total    = json.total
      @received += json?.data?.length or 0

      console.log ''
      console.log "Received : [#{chalk.green(@received)}/#{chalk.green(@total)}]"
      console.log ''

      deferred.resolve json
    deferred.promise


  getOptions: =>
    url: "https://api.vimeo.com/users/#{@user}/videos?page=#{@page}&per_page=#{@per_page}"
    headers:
      'Content-Type': 'application/json'
      'Authorization': 'bearer 17e72db60b900c416635d38d218ee460'
      'host': 'api.vimeo.com'

  checkTotalData: =>

    deferred = Q.defer()
    if @received < @total
      # Increment page
      @page += 1

      deferred.reject()
    else
      deferred.resolve()
    deferred.promise



  getVideoIdArray: (json) ->
    deferred = Q.defer()
    arr      = []

    _.each json.data, (item) ->
      uri   = item.uri
      split = uri.split('/')
      _id   = parseInt(split[2])
      arr.push
        _id: _id
        status: 'queue'

    deferred.resolve arr
    deferred.promise







module.exports = User

