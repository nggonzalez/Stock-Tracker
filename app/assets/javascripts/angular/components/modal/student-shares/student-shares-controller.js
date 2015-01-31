modal.controller('StudentSharesCtrl', ['$scope', '$modalInstance', 'Mentor', 'args', 'Alerts', 'Error',
  function ($scope, $modalInstance, Mentor, args, Alerts, Error) {
    // Get shares
    var employeeId = args[3];
    Mentor.shares({}, {student: employeeId}).$promise.then(function (student) {
      $scope.shares = student.shares;
      $scope.aggregateTotal = student.aggregateTotalShares;
      $scope.aggregateEarned = student.aggregateEarnedShares;
      $scope.student = student.student;
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'student shares', 'load'));
    });

    $scope.close = function () {
      $modalInstance.dismiss('cancel');
    };
}]);