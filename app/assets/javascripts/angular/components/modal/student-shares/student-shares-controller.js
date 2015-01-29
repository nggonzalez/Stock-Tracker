modal.controller('StudentSharesCtrl', ['$scope', '$modalInstance', 'Mentor', 'args', 'Alerts',
  function ($scope, $modalInstance, Mentor, args, Alerts) {
    // Get shares
    var employeeId = args[3];
    Mentor.shares({}, {student: employeeId}).$promise.then(function (student) {
      $scope.shares = student.shares;
      $scope.aggregateTotal = student.aggregateTotalShares;
      $scope.aggregateEarned = student.aggregateEarnedShares;
      $scope.student = student.student;
      console.log(student);
    }, function (error) {
      Alerts.showAlert('danger', 'Error loading student shares.');
    });

    $scope.close = function () {
      $modalInstance.dismiss('cancel');
    };
}]);