var offers = angular.module('offers', ['offerDirective']);

offers.controller('OffersCtrl', [function () {
  this.offers = [{shares: 10000, company: "Team 1", ceo: "Student", offerDate: new Date(), new: true}];
}]);