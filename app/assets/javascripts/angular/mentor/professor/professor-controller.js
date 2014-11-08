var professor = angular.module('professor', ['mentorService', 'alertsService']);
professor.controller('ProfessorCtrl', ['$scope', 'Mentor', 'Alerts', function ($scope, Mentor, Alerts) {
  Mentor.professor({}, {}).$promise.then(function (students) {
    $scope.students = students.mentor;
  }, function (error) {
    Alerts.showAlert('danger', 'Error loading student data.');
  });
}]);