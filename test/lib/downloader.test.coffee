'use strict'

fs                = require 'fs'
path              = require 'path'

# *Class*
Downloader        = require '../../lib/downloader'


describe 'lib', ->

  describe 'downloader class', ->

    before ->
      @downloader = new Downloader()

    after ->
      @downloader = null


    it 'should be a class', ->
      expect(@downloader).to.be.instanceof(Downloader)

    it 'should have public methods', ->
      expect(@downloader).to.have.property('exec')

    it 'should have private methods', ->
      expect(@downloader).to.have.property('_downloadVideo')
      expect(@downloader).to.have.property('_parseHTMLString')
      expect(@downloader).to.have.property('_getVimeoPage')
      expect(@downloader).to.have.property('_complete')
      expect(@downloader).to.have.property('_reject')

  #  it 'should get vimeo page', (done) ->
  #    @timeout(20000)
  #    @downloader._getVimeoPage('104330259')
  #    .then (results) ->
  #      status  = results.status
  #      text    = results.text
  #      expect(status).to.equals(200)
  #      expect(text).to.be.a('string')
  #      done()

#    it 'should parse get vimeo page results', (done) ->
#      @timeout(20000)
#      fixture = path.resolve(__dirname, '../_fixtures/vimeopage.fixture.txt')
#      fs.readFile fixture, 'utf-8', (err, text) =>
#        if err
#          throw err
#        else
#          @downloader._parseHTMLString(text)
#          .then (resolve) ->
#            expect(resolve).to.be.an('object')
#            expect(resolve).to.have.property('id', 104330259)
#            expect(resolve).to.have.property('title', 'Moments In Asia - iPhone 5s 120fps')
#            expect(resolve).to.have.property('url', 'https://pdlvimeocdn-a.akamaihd.net/32263/729/281819636.mp4?token2=1416671515_e56d18585d6f1204c6ef9980886ffe37&aksessionid=29b23a582c998808')
#            expect(resolve).to.have.property('filename', 'Moments In Asia - iPhone 5s 120fps - 104330259.mp4')
#            done()

  #  it 'should download', (done) ->
  #    @timeout(20000)
  #    vimeo =
  #      id: 104330259
  #      title: 'Moments In Asia - iPhone 5s 120fps'
  #      url: 'https://pdlvimeocdn-a.akamaihd.net/32263/729/281819636.mp4?token2=1416671515_e56d18585d6f1204c6ef9980886ffe37&aksessionid=29b23a582c998808'
  #      filename: 'Moments In Asia - iPhone 5s 120fps - 104330259.mp4'
  #
  #    @downloader._downloadVideo(vimeo).then (resolve) ->
  #      done()

