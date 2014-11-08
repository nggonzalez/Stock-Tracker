var offerDirective = angular.module('offerDirective', ['offersService', 'alertsService']);

offerDirective.directive('offer', ['Offers', 'Alerts', function (Offers, Alerts) {
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
        }, function () {
          Alerts.showAlert('danger', 'Error recording offer acceptance.');
        });
      };
      scope.decline = function() {
        scope.offerData.answered = true;
        scope.offerData.signed = false;
        scope.offerData.dateSigned = new Date();
        Offers.update({}, scope.offerData).$promise.then(function () {
          Alerts.showAlert('success', 'Successfully declined offer.');
        }, function () {
          Alerts.showAlert('danger', 'Error recording offer rejection.');
        });
      };
    }
  };
}]);
