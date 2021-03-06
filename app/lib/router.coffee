Router.configure
  layoutTemplate: "mainLayout"
  loadingTemplate: "loading"


class CoinsManagerController extends RouteController
  data: ->
    do GAnalytics.pageview

    coinsManager = Meteor.users.findOne
      "emails.address": Meteor.settings.public.email

    if coinsManager
      userAddresses = {}
      allAddresses = {}
      donationAddresses = Addresses.find(
        userId: coinsManager._id
      ).fetch()

      user = Meteor.user()
      if user
        userAddresses = Addresses.find(
          userId: Meteor.user()._id
        ).fetch()

      if coinsManager and user
        allAddresses = Addresses.find(
          $or: [
            {userId: coinsManager._id}
            {userId: Meteor.user()._id}
          ]
        ).fetch()
        Session.set "showDonationAddresses", false
        Session.set "visibleAddresses", userAddresses
      else
        Session.set "showDonationAddresses", true
        Session.set "visibleAddresses", donationAddresses

      result =
        donationAddresses: donationAddresses
        userAddresses: userAddresses
        allAddresses: allAddresses
      return result


Router.map ->
  @route "alpha",
    path: "/"
    controller: CoinsManagerController
    waitOn: ->
      collections = ["users", "donationAddresses"]
      Meteor.subscribe collection for collection in collections
      if Meteor.user()
        Meteor.subscribe "userAddresses", Meteor.user()._id
