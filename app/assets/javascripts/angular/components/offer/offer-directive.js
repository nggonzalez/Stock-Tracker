var offerDirective = angular.module('offerDirective', ['offersService']);

offerDirective.directive('offer', ['Offers', function (Offers) {
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
        scope.offerData.responded = true;
        scope.offerData.signed = true;
        scope.offerData.dateSigned = new Date();
        Offers.update({}, scope.offerData);
      };
      scope.decline = function() {
        scope.offerData.responded = true;
        scope.offerData.signed = false;
        scope.offerData.dateSigned = new Date();
        Offers.update({}, scope.offerData);
      };
    }
  };
}]);
