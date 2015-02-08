var newInvestment = angular.module('newInvestment', ['alertsService', 'errorsService']);
newInvestment.controller('NewInvestmentCtrl', ['$scope', 'args', 'Investment',
  'Alerts', 'Error', '$modalInstance', 'args', function ($scope, args, Investment, Alerts, Error, $modalInstance, args) {
    $scope.investment = {
      team_id: args[2].team_id
    };

    $scope.investableDollars = args[3].investable_shares - args[3].invested_shares;
    $scope.companyData = args[2];

    $scope.discard = function () {
      $modalInstance.dismiss('cancel');
    };

    $scope.confirm = function () {
      Investment.save({}, $scope.investment).$promise.then(function (investment) {
        Alerts.showAlert('success', 'Successfully invested $' + $scope.investment.dollars + ' in ' + args[2].company_name + '.');
        args[2].currentInvestment += $scope.investment.dollars;
        args[3].invested_shares += $scope.investment.dollars;
      }, function (error) {
        Alerts.showAlert('danger', Error.createMessage(error.status, 'investment', 'save'));
      });
      $modalInstance.close($scope.investment);
    };
}]);
