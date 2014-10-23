var offerDirective = angular.module('offerDirective', []);

offerDirective.directive('offer', [function () {
  var link = function (scope, element, attrs, offerCtrl) {
    var acceptButton = angular.element(element[0].querySelector('.accept'));
    var declineButton = angular.element(element[0].querySelector('.decline'));

    acceptButton.bind('click', function () {
      console.log('accept');
    });

    declineButton.bind('click', function () {
      console.log('decline');
    });
  };

  return {
    restrict: 'E',
    replace: true,
    scope: {
      offerData: '='
    },
    link: link,
    templateUrl: '/templates/directives/offer.html',
  };
}]);