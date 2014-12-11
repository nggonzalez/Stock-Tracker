var professor = angular.module('professor', ['mentorService', 'alertsService', 'modalService']);
professor.controller('ProfessorCtrl', ['$scope', 'Mentor', 'Alerts', 'Modal', function ($scope, Mentor, Alerts, Modal) {
  Mentor.professor({}, {}).$promise.then(function (students) {
    $scope.students = students.mentor;
  }, function (error) {
    Alerts.showAlert('danger', 'Error loading student data.');
  });

  $scope.seeShares = function (student) {
    Modal.open('/templates/modals/studentshares.html', 'StudentSharesCtrl', -1, student.id);
  };
}]);