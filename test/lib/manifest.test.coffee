'use strict'


# *Class*
Manifest    = require '../../lib/manifest'


describe 'lib', ->

  describe 'manifest class', ->

    before ->
      @manifest = new Manifest
        download_dir : ''
        base_url : ''

    after ->
      @manifest = null

    it 'should be a class', ->
      expect(@manifest).to.be.instanceof(Manifest)

    it 'should have properties', ->
      expect(@manifest).to.have.property('db')

    it 'should have public methods', ->
      expect(@manifest).to.have.property('update')
      expect(@manifest).to.have.property('create')
      expect(@manifest).to.have.property('queue')
      expect(@manifest).to.have.property('complete')
      expect(@manifest).to.have.property('downloading')
      expect(@manifest).to.have.property('getNextQueue')
      expect(@manifest).to.have.property('getNextDownloading')
      expect(@manifest).to.have.property('getDownloadingCount')
      expect(@manifest).to.have.property('getQueueCount')
      expect(@manifest).to.have.property('getCompleteCount')

    it 'should create new manifest', (done) ->
      @timeout(20000)
      @manifest.queue(104330259)
      .then (results) ->
        expect(results).to.have.property '_id', 104330259
        expect(results).to.have.property 'status', 'queue'
        done()

    it 'should update status to downloading', (done) ->
      @manifest.downloading(104330259)
      .then (results) ->
        expect(results).to.have.property '_id', 104330259
        expect(results).to.have.property 'status', 'downloading'
        done()

    it 'should update status to complete', (done) ->
      @manifest.complete(104330259)
      .then (results) ->
        expect(results).to.have.property '_id', 104330259
        expect(results).to.have.property 'status', 'complete'
        done()

    it 'should get the next queue to download', (done) ->
      @timeout(20000)
      @manifest.queue(104330259)
      .then =>
        @manifest.getNextQueue().then (results) ->
          expect(results).to.equals(104330259)
          done()

    it 'should get the total downloading count', (done) ->
      @manifest.getDownloadingCount().then (results) ->
        expect(results.downloading_count).to.be.a('number')
        expect(results.downloading_count).to.equals(1)
        done()

    it 'should get the total queue count', (done) ->
      @manifest.getQueueCount().then (results) ->
        expect(results.queue_count).to.be.a('number')
        expect(results.queue_count).to.equals(2)
        done()

    it 'should get the total complete count', (done) ->
      @manifest.getCompleteCount().then (results) ->
        expect(results.complete_count).to.be.a('number')
        expect(results.complete_count).to.equals(0)
        done()