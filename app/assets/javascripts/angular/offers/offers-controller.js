var offers = angular.module('offers', ['offerDirective', 'offersService', 'alertsService', 'errorsService']);
offers.controller('OffersCtrl', ['$scope', 'Offers', 'Alerts', 'Error', function ($scope, Offers, Alerts, Error) {
  Offers.get().$promise.then(function (offersData) {
    $scope.offers = offersData.offers;
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'offers', 'load'));
  });

  $scope.student = $scope.$parent.student;
}]);
