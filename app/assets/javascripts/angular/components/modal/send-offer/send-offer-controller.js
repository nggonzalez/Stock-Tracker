modal.controller('SendOfferCtrl', ['$scope', '$modalInstance', 'Offers', 'Student', 'Team',
  'args', 'Alerts', function ($scope, $modalInstance, Offers, Student, Team, args, Alerts) {
    // Setup new offer
    // Send it
    var teamId = args[2];
    Student.query({all: 'all'}).$promise.then(function (students) {
      $scope.students = students.students;
    }, function (error) {
      Alerts.showAlert('danger', 'Error loading students.');
    });

    Team.shares({}, {id: teamId}).$promise.then(function (shares) {
      $scope.maxSharesOfferable = shares.shares;
    }, function (error) {
      Alerts.showAlert('danger', 'Error loading maxSharesOfferable.');
    });

    $scope.offer = {
      team: teamId
    };

    $scope.send = function () {
      var offer = $scope.offer;
      offer.student = offer.student.id
      Offers.save({}, $scope.offer).$promise.then(function () {
        Alerts.showAlert('success', 'Successfully sent offer.');
      }, function (error) {
        Alerts.showAlert('danger', 'Error sending offer.');
      });
      $modalInstance.close($scope.offer);
    };

    $scope.discard = function () {
      $modalInstance.dismiss('cancel');
    };
}]);
