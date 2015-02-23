var invest = angular.module('invest', ['investmentService', 'errorsService', 'alertsService', 'modalService']);
invest.controller('InvestCtrl', ['$scope','Investment', 'Error', 'Alerts', 'Modal', function($scope, Investment, Error, Alerts, Modal) {
  var parseFloats = function (valuations) {
    for (var i = 0, length = valuations.length; i < length; i++) {
      valuations[i].currentInvestmentShares = parseFloat(valuations[i].currentInvestmentShares, 10);
      valuations[i].currentInvestmentDollars = parseFloat(valuations[i].currentInvestmentDollars, 10);
    }
  };

  Investment.get({}, {}).$promise.then(function (teamValuations) {
    console.log(teamValuations);
    $scope.teams = teamValuations.investment;
    $scope.student = teamValuations.student;
    $scope.rank = teamValuations.rank;
    parseFloats(teamValuations.investment);
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'teams and valuations', 'load'));
  });

  $scope.createInvestment = function(valuation) {
    Modal.open('/templates/modals/invest.html', 'NewInvestmentCtrl', valuation, $scope.student);
  };
}]);