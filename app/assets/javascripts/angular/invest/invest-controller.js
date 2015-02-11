var invest = angular.module('invest', ['investmentService', 'errorsService', 'alertsService', 'modalService']);
invest.controller('InvestCtrl', ['$scope','Investment', 'Error', 'Alerts', 'Modal', function($scope, Investment, Error, Alerts, Modal) {
  var parseFloats = function (valuations) {
    for (var i = 0, length = valuations.valuation.length; i < length; i++) {
      var roundVals = valuations.valuation[i].valuations;
      for(var j = 0, valLength = roundVals.length; j < valLength; j++) {
        roundVals[j].currentInvestmentShares = parseFloat(roundVals[j].currentInvestmentShares, 10);
        roundVals[j].currentInvestmentDollars = parseFloat(roundVals[j].currentInvestmentDollars, 10);
      }
    }
  };

  Investment.get({}, {}).$promise.then(function (teamValuations) {
    $scope.teams = teamValuations.investment;
    $scope.student = teamValuations.student;
    parseFloats(teamValuations);
    console.log(teamValuations);
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'teams and valuations', 'load'));
  });

  $scope.createInvestment = function(valuation) {
    Modal.open('/templates/modals/invest.html', 'NewInvestmentCtrl', valuation, $scope.student);
  };
}]);