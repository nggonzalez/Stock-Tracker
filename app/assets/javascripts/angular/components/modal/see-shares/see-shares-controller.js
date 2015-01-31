modal.controller('SeeSharesCtrl', ['$scope', '$modalInstance', 'Shares',
  'Offers', 'args', 'Alerts', 'Error',
  function ($scope, $modalInstance, Shares, Offers, args, Alerts, Error) {
    // Get shares
    var employeeId = args[3];
    var teamId = args[2];
    Shares.getEmployeeShares({}, {employee: employeeId, team:teamId}).$promise.then(function (employee) {
      $scope.shares = employee.offers.shares;
      $scope.employee = employee.employee;
      $scope.eligibleForOffer = employee.eligibleForOffer;
      $scope.maxSharesOfferable = employee.distributableShares;
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'shares', 'load'));
    });

    $scope.newOffer = false;
    $scope.offer = {
      team: teamId,
      student: employeeId
    };

    $scope.toggleNewOffer = function () {
      $scope.newOffer = !$scope.newOffer;
    };

    $scope.send = function () {
      Offers.save({}, $scope.offer).$promise.then(function () {
        Alerts.showAlert('success', 'Successfully sent offer.');
      }, function (error) {
        Alerts.showAlert('danger', Error.createMessage(error.status, 'offer', 'send new'));
      });
      $modalInstance.close();
    };

    $scope.close = function () {
      $modalInstance.dismiss('cancel');
    };
}]);