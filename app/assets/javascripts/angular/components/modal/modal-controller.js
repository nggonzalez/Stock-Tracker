var modal = angular.module('modalService', ['sharesService', 'offersService', 'studentService']);
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
  'employeeId', 'teamId',
  function ($scope, $modalInstance, Shares, employeeId, teamId) {
    // Get shares
    Shares.getEmployeeShares({}, {employee: employeeId, team:teamId}).$promise.then(function (employee) {
      $scope.shares = employee.offers.shares;
      $scope.employee = employee.employee;
      $scope.eligibleForOffer = employee.eligibleForOffer;
    }, function (error) {
      console.log(error.status);
    });

    $scope.newOffer = false;
    $scope.offer = {
      team: 0,
      employeeId: employeeId
    };

    $scope.toggleNewOffer = function () {
      $scope.newOffer = !$scope.newOffer;
    };

    $scope.send = function () {
      $modalInstance.close($scope.offer);
    };

    $scope.close = function () {
      $modalInstance.dismiss('cancel');
    };
}]);


modal.controller('SendOfferCtrl', ['$scope', '$modalInstance', 'Offers', 'Student',
  'teamId', function ($scope, $modalInstance, Offers, Student, teamId) {
    // Setup new offer
    // Send it
    Student.query({all: 'all'}).$promise.then(function (students) {
      $scope.students = students.students;
      console.log(students);
    }, function (error) {
      console.log(error.status);
    });

    $scope.offer = {
      team: teamId
    };

    $scope.send = function () {
      console.log($scope.offer);
      $modalInstance.close($scope.offer);
    };

    $scope.discard = function () {
      $modalInstance.dismiss('cancel');
    };
}]);