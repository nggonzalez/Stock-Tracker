var invest = angular.module('invest', ['investmentService', 'errorsService', 'alertsService', 'modalService']);
invest.controller('InvestCtrl', ['$scope','Investment', 'Error', 'Alerts', 'Modal', function($scope, Investment, Error, Alerts, Modal) {
  Investment.get({}, {}).$promise.then(function (teamValuations) {
    $scope.teams = teamValuations.investment;
    $scope.student = teamValuations.student;
    console.log(teamValuations);
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'teams and valuations', 'load'));
  });

  $scope.createInvestment = function(valuation) {
    Modal.open('/templates/modals/invest.html', 'NewInvestmentCtrl', valuation, $scope.student);
  };
}]);