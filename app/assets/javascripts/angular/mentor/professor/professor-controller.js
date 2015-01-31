var professor = angular.module('professor', ['mentorService', 'alertsService', 'modalService', 'errorsService']);
professor.controller('ProfessorCtrl', ['$scope', 'Mentor', 'Alerts', 'Modal', 'Error', function ($scope, Mentor, Alerts, Modal, Error) {
  Mentor.professor({}, {}).$promise.then(function (students) {
    $scope.students = students.mentor;
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(status, 'professor view data', 'load'));
  });

  $scope.seeShares = function (student) {
    Modal.open('/templates/modals/studentshares.html', 'StudentSharesCtrl', -1, student.id);
  };
}]);