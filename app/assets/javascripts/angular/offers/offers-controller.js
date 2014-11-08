var offers = angular.module('offers', ['offerDirective', 'offersService', 'alertsService']);
offers.controller('OffersCtrl', ['$scope', 'Offers', 'Alerts', function ($scope, Offers, Alerts) {
  Offers.get().$promise.then(function (offersData) {
    $scope.offers = offersData.offers;
  }, function (error) {
    Alerts.showAlert('danger', 'Error loading offers.');
  });

  $scope.student = $scope.$parent.student;
}]);
