var offerDirective = angular.module('offerDirective', ['offersService', 'alertsService', 'errorsService']);

offerDirective.directive('offer', ['Offers', 'Alerts', 'Error', function (Offers, Alerts, Error) {
  return {
    restrict: 'E',
    replace: true,
    scope: {
      offerData: '=',
      ceo: '@'
    },
    templateUrl: '/templates/directives/offer.html',
    link: function(scope) {
      scope.accept = function() {
        scope.offerData.answered = true;
        scope.offerData.signed = true;
        scope.offerData.dateSigned = new Date();
        Offers.update({}, scope.offerData).$promise.then(function () {
          Alerts.showAlert('success', 'Successfully accepted offer.');
        }, function (error) {
          Alerts.showAlert('danger', Error.createMessage(error.status, 'offer', 'accept'));
        });
      };
      scope.decline = function() {
        scope.offerData.answered = true;
        scope.offerData.signed = false;
        scope.offerData.dateSigned = new Date();
        Offers.update({}, scope.offerData).$promise.then(function () {
          Alerts.showAlert('success', 'Successfully declined offer.');
        }, function (error) {
          Alerts.showAlert('danger', Error.createMessage(error.status, 'offer', 'decline'));
        });
      };
    }
  };
}]);
