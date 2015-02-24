var groups = angular.module('groups', ['mentorService', 'alertsService', 'modalService', 'errorsService', 'studentService']);
groups.controller('GroupsCtrl', ['$scope', 'Mentor', 'Alerts', 'Modal', 'Error', 'Student', function ($scope, Mentor, Alerts, Modal, Error, Student) {
  Mentor.groups({}, {}).$promise.then(function (groups) {
    $scope.groups = groups.mentor;
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'mentor\'s teams', 'load'));
  });

  $scope.dropStudent = function (student, groupIndex, employeeIndex) {
    if(!confirm("Are you sure you want to drop " + student.firstname + ' ' + student.lastname  + " from the class? This action cannot be undone.\n\nIf the student is a CEO, please consult with the webmaster first.")) {
      return;
    }
    Student.drop({}, {id: student.id}).$promise.then(function (data) {
      Alerts.showAlert('success', 'Successfully dropped ' + student.firstname + ' ' + student.lastname  + ' from the class.');
      $scope.groups[groupIndex].employees.splice(employeeIndex, 1);
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'student', 'drop'));
    });
  };

  $scope.seeShares = function (student) {
    Modal.open('/templates/modals/studentshares.html', 'StudentSharesCtrl', -1, student.id);
  };

  $scope.seeOffers = function (team) {
    Modal.open('/templates/modals/seeoffers.html', 'SeeOffersCtrl', team, undefined);
  };
}]);