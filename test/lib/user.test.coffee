'use strict'


# *Class*
User    = require '../../lib/user'

# *Fixtures*
videosFixture = require '../_fixtures/videos.fixture.json'


describe 'lib', ->

  describe 'manifest class', ->

    before ->
      @user = new User('jasonmagbanua')

    after ->
      @user = null

    it 'should be a class', ->
      expect(@user).to.be.instanceof(User)

    it 'should have properties', ->
      expect(@user).to.have.property('user', 'jasonmagbanua')
      expect(@user).to.have.property('page', 1)
#      expect(@user).to.have.property('per_page', 50)

    it 'should have public methods', ->
      expect(@user).to.have.property('exec')
      expect(@user).to.have.property('getUserVideos')
      expect(@user).to.have.property('getVideoIdArray')

#    it 'should get user videos', (done) ->
#      @timeout(200000)
#      @user.getUserVideos().then (results) ->
#        console.log 'results: ', results
#        done()

#    it 'should get video _id array', (done) ->
#      @user.getVideoIdArray(videosFixture).then (results) ->
#        expect(results).to.be.instanceof(Array)
#        expect(results[0]).to.have.property('_id', 111722935)
#        done()

    it 'should get video arrays', (done) ->
      @timeout(200000)
      @user.exec()
      .then (results) ->
        done()

