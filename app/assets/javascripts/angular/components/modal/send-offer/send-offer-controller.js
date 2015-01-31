modal.controller('SendOfferCtrl', ['$scope', '$modalInstance', 'Offers', 'Student', 'Team',
  'args', 'Alerts', 'Error', function ($scope, $modalInstance, Offers, Student, Team, args, Alerts, Error) {
    // Setup new offer
    // Send it
    var teamId = args[2];
    Student.query({all: 'all'}).$promise.then(function (students) {
      $scope.students = students.students;
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'students', 'load'));
    });

    Team.shares({}, {id: teamId}).$promise.then(function (shares) {
      $scope.maxSharesOfferable = shares.shares;
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'team shares', 'load'));
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
        Alerts.showAlert('danger', Error.createMessage(error.status, 'offer', 'send'));
      });
      $modalInstance.close($scope.offer);
    };

    $scope.discard = function () {
      $modalInstance.dismiss('cancel');
    };
}]);
