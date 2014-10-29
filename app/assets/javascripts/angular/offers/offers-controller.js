var offers = angular.module('offers', ['offerDirective', 'offersService']);

offers.controller('OffersCtrl', ['$scope', 'Offers', function ($scope, Offers) {
  Offers.get().$promise.then(function (offersData) {
    $scope.offers = offersData.offers;
  }, function (error) {
    console.log(error.status);
  });
}]);
