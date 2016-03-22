/*
Tests for BranchSDK.

Expected results:

Branch Unit Tests
    Initialize Branch
        o initSession(): OK - event will fire
    Basic Methods
        o getLatestReferringParams(): OK - not null
        o getFirstReferringParams(): OK - not null
        o setIdentity(): OK - no error
        o userCompletedAction(): OK - no error
    Referral Rewarding Methods
        o loadRewards(): OK - event will fire
        o getCreditHistory(): OK - event will fire
        o redeemRewards(): OK - event will not fire due to insufficient rewards
*/


var assert = require('chai').assert;
var branch = require('io.branch.sdk');
var branchUniversalObject;

branch.addEventListener("bio:initSession", function(data) {
    Ti.API.debug(JSON.stringify(data));
});
branch.addEventListener("bio:loadRewards", function(data) {
    Ti.API.debug(JSON.stringify(data));
});
branch.addEventListener("bio:getCreditHistory", function(data) {
    Ti.API.debug(JSON.stringify(data));
});
branch.addEventListener("bio:redeemRewards", function(data) {
    Ti.API.debug(JSON.stringify(data));
});

module.exports = function() {

    describe('Branch Unit Tests', function() {

        describe('Initialize Branch', function() {

            it('initSession()', function(done){
                this.timeout(0);
                var errTimeout = setTimeout(function() {
                    assert(false, 'Event never fired');
                    done();
                }, 10000);

                branch.on('bio:initSession',function() {
                    clearTimeout(errTimeout);
                    assert(true, 'Event fired');
                    done();
                });

                branch.setDebug();
                branch.initSession();
            });

        });

        describe('Basic Methods', function() {

            it('getLatestReferringParams()', function() {
                var sessionParams = branch.getLatestReferringParams();
                assert.isNotNull(sessionParams, 'sessionParams not null');
            });

            it('getFirstReferringParams()', function() {
                var installParams = branch.getFirstReferringParams();
                assert.isNotNull(installParams, 'installParams not null');
            });

            it('setIdentity()', function() {
                branch.setIdentity('test-identity');
                assert(true, 'Success');
            });

            it('userCompletedAction()', function() {
                branch.userCompletedAction('test-action');
                assert(true, 'Success');
            });

        });

        describe('Referral Rewarding Methods', function() {

            it('loadRewards()', function(done) {
                this.timeout(0);
                var errTimeout = setTimeout(function() {
                    assert(false, 'Event never fired');
                    done();
                }, 10000);

                branch.on('bio:loadRewards', function() {
                    clearTimeout(errTimeout);
                    assert(true, 'Event fired');
                    done();
                });

                branch.loadRewards();
            });

            it('getCreditHistory()', function(done){
                this.timeout(0);
                var errTimeout = setTimeout(function() {
                    assert(false, 'Event never fired');
                    done();
                }, 10000);

                branch.on('bio:getCreditHistory', function() {
                    clearTimeout(errTimeout);
                    assert(true, 'Event fired');
                    done();
                });

                branch.getCreditHistory();
            });

            it('redeemRewards()', function(done){
                this.timeout(0);
                var errTimeout = setTimeout(function() {
                    assert(true, 'Event will not fire because of insufficient credits');
                    done();
                }, 10000);

                branch.on('bio:redeemRewards', function() {
                    clearTimeout(errTimeout);
                    assert(true, 'Event not supposed to be fired');
                    done();
                });

                branch.redeemRewards(5);
            });

        });

        describe('Initialize Branch Universal Object', function() {

            it('createBranchUniversalObject()', function(){

                branchUniversalObject = branch.createBranchUniversalObject({
                    "canonicalIdentifier" : "test-id",
                    "title" : "test-title",
                    "contentDescription" : "This is a test",
                    "contentImageUrl" : "http://testimageurl.com/media/1235904.jpg",
                    "contentIndexingMode" : "private",
                    "contentMetadata" : {
                        "testKey" : "test",
                        "testKey2" : "test2"
                    },
                });

                // Branch Universal Object Listeners
                branchUniversalObject.addEventListener("bio:generateShortUrl", function(data){

                });

                if (OS_ANDROID) {
                    branchUniversalObject.addEventListener("bio:shareLinkDialogLaunched", function(data){

                    });
                    branchUniversalObject.addEventListener("bio:shareLinkDialogDismissed", function(data){

                    });
                    branchUniversalObject.addEventListener("bio:shareLinkResponse", function(data){

                    });
                    branchUniversalObject.addEventListener("bio:shareChannelSelected", function(data){

                    });
                }

                assert.isNotNull(branchUniversalObject, 'branchUniversalObject not null');
            });

        });

        describe('Branch Universal Object Methods', function() {

            it('registerView()', function() {
                branchUniversalObject.registerView();
                assert(true, 'Success');
            });

            it('generateShortUrl()', function(done){
                this.timeout(0);
                var errTimeout = setTimeout(function() {
                    assert(false, 'Event never fired');
                    done();
                }, 10000);

                branchUniversalObject.on('bio:generateShortUrl', function() {
                    clearTimeout(errTimeout);
                    assert(true, 'Event fired');
                    done();
                });

                branchUniversalObject.generateShortUrl({
                    "feature" : "test-feature",
                    "channel" : "test-channel",
                    "stage" : "test-stage",
                    "duration" : 1,
                }, {
                    "$desktop_url" : "http://test_url.com",
                });
            });

            it('showShareSheet()', function(done){
                this.timeout(0);
                var errTimeout = setTimeout(function() {
                    assert(false, 'Event never fired');
                    done();
                }, 10000);

                branchUniversalObject.on('bio:shareLinkDialogLaunched', function() {
                    clearTimeout(errTimeout);
                    assert(true, 'Event fired');
                    done();
                });

                branchUniversalObject.showShareSheet({
                    "feature" : "test-share-feature",
                    "channel" : "test-share-channel",
                    "stage" : "test-share-stage",
                    "duration" : 1,
                }, {
                    "$desktop_url" : "http://test_share_url.com",
                    "$email_subject" : "This is a test subject",
                    "$email_body" : "This is a test body",
                });
            });

        });

    });

    mocha.run();
};
