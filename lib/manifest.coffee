'use strict'

# *Modules*
_         = require 'underscore'
Q         = require 'q'
moment    = require 'moment'
LocalDB   = require 'localdb'
chalk     = require 'chalk'

class Manifest

  constructor: (data) ->
     # Create new instance of Manifest Class.
    if not (@ instanceof Manifest)

      # This will return object {}
      return new Manifest()

    @download_dir       = data.download_dir
    @base_url           = data.base_url
    @db                 = new LocalDB('Manifest', process.cwd())

  create: (deferred, params) ->
    @db.create params, (error, results) ->
      if error
        deferred.reject error
      else
        deferred.resolve results

  update: (deferred, filter, params) ->
    @db.update filter, params, (error, results) ->
      if error
        deferred.reject error
      else
        deferred.resolve results

  delete: (filters) ->
    deferred  = Q.defer()
    @db.delete filters,(error, results) ->
      if error
        deferred.reject error
      else
        deferred.resolve results
    deferred.promise

  # To create a queue
  #
  #     @param {number} _id
  #
  queue: (_id) =>
    deferred  = Q.defer()
    if _id
      @create deferred,
        _id: _id
        status: 'queue'
    else
      deferred.resolve()

    deferred.promise

  complete: (_id) =>
    deferred  = Q.defer()
    @update deferred, {_id: _id}, {status: 'complete'}
    deferred.promise

  downloading: (_id) =>
    deferred  = Q.defer()
    @update deferred, {_id: _id}, {status: 'downloading'}
    deferred.promise

  getNextQueue: =>
    deferred  = Q.defer()
    @db.findOne {status:'queue'}, (error, results) ->
      console.log ''
      if results?._id
        status = results?._id or ''
        status = "#{status}"
        console.log "Next queue : #{chalk.yellow(status)}"
      if error or results is null
        deferred.resolve null
      else
        deferred.resolve results._id
    deferred.promise

  getNextDownloading: (_id) =>
    if _id
      _id
    else
      deferred  = Q.defer()
      @db.findOne {status:'downloading'}, (error, results) ->
        if results?._id
          status = results?._id or ''
          status = "#{status}"
          console.log("Next download : #{chalk.yellow(status)}")
        if error or results is null
          deferred.reject 'All downloads are complete!'
        else
          deferred.resolve results._id
      deferred.promise

  getDownloadingCount: (resolve = {}) =>
    deferred = Q.defer()
    @db.find {status:'downloading'}, (error, results) ->
      deferred.resolve _.extend resolve,
        downloading_count: results.length
    deferred.promise

  getQueueCount: (resolve = {}) =>
    deferred = Q.defer()
    @db.find {status:'queue'}, (error, results) ->

      deferred.resolve _.extend resolve,
        queue_count: results.length
    deferred.promise

  getCompleteCount: (resolve = {}) =>
    deferred = Q.defer()
    @db.find {status:'complete'}, (error, results) ->
      deferred.resolve _.extend resolve,
        complete_count: results.length
    deferred.promise

  outputCountResults: (resolve) ->
    console.log ''
    console.log chalk.magenta('---------------------------')
    console.log ''
    console.log "Queue : #{chalk.green(resolve.queue_count)}"
    console.log "Downloading : #{chalk.green(resolve.downloading_count)}"
    console.log "Complete : #{chalk.green(resolve.complete_count)}"
    resolve


module.exports = Manifest

