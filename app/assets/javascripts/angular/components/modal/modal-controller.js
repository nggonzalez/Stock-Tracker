var modal = angular.module('modalService', ['sharesService', 'offersService', 'studentService', 'alertsService', 'teamService', 'mentorService']);
modal.factory('Modal', ['$modal', function ($modal) {
  var Modal = {
    open: function (modalTemplate, modalCtrl, teamId, employeeId) {
      var modalInstance = $modal.open({
        templateUrl: modalTemplate,
        controller: modalCtrl,
        resolve: {
          employeeId: function() {
            return employeeId || undefined;
          },
          teamId: function() {
            return teamId;
          }
        }
      });
      console.log(modalTemplate, modalCtrl);

      modalInstance.result.then(function (selectedItem) {
        //
      }, function () {
        // $log.info('Modal dismissed at: ' + new Date());
      });
    }
  };

  return Modal;
}]);


modal.controller('SeeSharesCtrl', ['$scope', '$modalInstance', 'Shares',
  'Offers', 'employeeId', 'teamId', 'Alerts',
  function ($scope, $modalInstance, Shares, Offers, employeeId, teamId, Alerts) {
    // Get shares
    Shares.getEmployeeShares({}, {employee: employeeId, team:teamId}).$promise.then(function (employee) {
      $scope.shares = employee.offers.shares;
      $scope.employee = employee.employee;
      $scope.eligibleForOffer = employee.eligibleForOffer;
      $scope.maxSharesOfferable = employee.distributableShares;
    }, function (error) {
      Alerts.showAlert('danger', 'Error loading employee shares.');
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
        Alerts.showAlert('danger', 'Error sending offer.');
      });
      $modalInstance.close();
    };

    $scope.close = function () {
      $modalInstance.dismiss('cancel');
    };
}]);


modal.controller('SendOfferCtrl', ['$scope', '$modalInstance', 'Offers', 'Student', 'Team',
  'teamId', 'Alerts', function ($scope, $modalInstance, Offers, Student, Team, teamId, Alerts) {
    // Setup new offer
    // Send it
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


modal.controller('StudentSharesCtrl', ['$scope', '$modalInstance', 'Mentor', 'employeeId', 'Alerts',
  function ($scope, $modalInstance, Mentor, employeeId, Alerts) {
    // Get shares
    Mentor.shares({}, {student: employeeId}).$promise.then(function (student) {
      $scope.shares = student.shares;
      $scope.student = student.student;
      console.log(student);
    }, function (error) {
      Alerts.showAlert('danger', 'Error loading student shares.');
    });

    $scope.close = function () {
      $modalInstance.dismiss('cancel');
    };
}]);

