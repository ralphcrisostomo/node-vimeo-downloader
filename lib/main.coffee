'use strict'

# *Modules*
Q           = require 'q'
chalk       = require 'chalk'

# *Class*
Downloader  = require './downloader'
User        = require './user'

module.exports = (commander)->
  user      = commander.user
  add       = commander.add
  download  = commander.download

  downloader = new Downloader()

  if download
    downloader.exec()

  if add
    downloader.queue(add)
    .then ->
      downloader.exec()

  if user
    user = new User(user)
    user.exec()
    .then ->
      downloader.exec()
