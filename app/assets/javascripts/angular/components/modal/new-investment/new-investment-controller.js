var newInvestment = angular.module('newInvestment', ['alertsService', 'errorsService']);
newInvestment.controller('NewInvestmentCtrl', ['$scope', 'args', 'Investment',
  'Alerts', 'Error', '$modalInstance', 'args', function ($scope, args, Investment, Alerts, Error, $modalInstance, args) {
    $scope.investment = {
      team_id: args[2].team_id
    };

    $scope.investableDollars = args[3].investable_dollars - args[3].invested_dollars;
    $scope.companyData = args[2];
    $scope.maxShares = Math.floor($scope.investableDollars/$scope.companyData.value);

    $scope.discard = function () {
      $modalInstance.dismiss('cancel');
    };

    $scope.confirm = function () {
      Investment.save({}, $scope.investment).$promise.then(function (investment) {
        Alerts.showAlert('success', 'Successfully purchased ' + $scope.investment.shares + ' shares ($' + ($scope.investment.shares * $scope.companyData.value) + ') in ' + args[2].company_name + '.');
        args[2].currentInvestmentDollars = parseFloat(args[2].currentInvestmentDollars, 10) +  $scope.investment.shares * $scope.companyData.value;
        args[2].currentInvestmentShares += $scope.investment.shares;
        args[3].invested_dollars = parseFloat(args[3].invested_dollars, 10) + $scope.investment.shares * $scope.companyData.value;
      }, function (error) {
        Alerts.showAlert('danger', Error.createMessage(error.status, 'investment', 'save'));
      });
      $modalInstance.close($scope.investment);
    };
}]);
