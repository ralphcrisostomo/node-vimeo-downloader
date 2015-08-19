# *Dependencies*
Q                 = require 'q'
superagent        = require 'superagent'
downloadStatus    = require 'download-status'
Download          = require 'download'
chalk             = require 'chalk'

# *Class*
Manifest          = require './manifest'

class Downloader extends Manifest

  constructor: ->
    super
      download_dir: process.cwd()
      base_url: 'https://player.vimeo.com/video/'


  exec: =>

    Q.fcall ->
      {}
    .then(@getQueueCount)
    .then(@getDownloadingCount)
    .then(@getCompleteCount)
    .then(@outputCountResults)
    .then(@getNextQueue)
    .then(@getNextDownloading)
    .then(@downloading)
    .then(@_getVimeoPage)
    .then(@_parseHTMLString)
    .then(@_downloadVideo)
    .then(@complete)
    .done(@exec, @_reject)



  #
  #     @param {string} video_id
  #     @resolve {string} html string
  #
  _getVimeoPage: (results) =>
    video_id = results._id
    console.log ''
    console.log chalk.blue("reading : #{@base_url}#{video_id}")
    deferred = Q.defer()
    superagent
    .get("#{@base_url}#{video_id}")
    .end (err, results) ->

      if err
        deferred.reject err
      else
        deferred.resolve results.text
    deferred.promise

  #
  #     @param {string} html_string
  #     @resolve {object} vimeo video data
  #
  _parseHTMLString: (html_string) =>

    console.log chalk.blue('parsing vimeo html string...')
    deferred    = Q.defer()
    regex_a     = /t={(.*)};if/
    regex_b     = /{(.*)}/
    result      = html_string.match(regex_a)

    if result is null
      deferred.reject '_parseHTMLString : results is null'
    else
      result    = result[0]?.match(regex_b)
      obj       = JSON.parse(result[0])

      if not obj?.request?.files?.h264?.hd
        @delete({_id: obj.video.id}).then ->
          deferred.reject "Video id '#{obj.video.id}', not found! :("
      else
        title = obj.video.title
        title = title.replace ':', ' - '

        vimeo     =
          id: obj.video.id
          title: obj.video.title
          url: obj.request.files.h264.hd.url
          filename: "#{title} [#{obj.video.id}].mp4"
        deferred.resolve vimeo
    deferred.promise

  #
  #     @param {object} vimeo
  #
  _downloadVideo: (vimeo) =>
    _id = vimeo.id
    console.log chalk.blue('downloading video...')
    deferred = Q.defer()
    download = new Download()
    .get(vimeo.url)
    .rename(vimeo.filename)
    .dest(@download_dir)
    .use(downloadStatus())
    .run (err, files) ->
      if err
        deferred.reject 'Download error: ', err
      else
        console.log 'Download complete : ' + chalk.green("'#{vimeo.filename}'")
        deferred.resolve _id
    deferred.promise



  _complete: ->

  _reject: (reject) ->
    if reject is 'All downloads are complete!'
      console.log ''
      console.log chalk.green("#{reject}")
    else
      console.log chalk.red("error : #{reject}")

module.exports = Downloader