var professor = angular.module('professor', ['mentorService']);
professor.controller('ProfessorCtrl', ['$scope', 'Mentor', function ($scope, Mentor) {
  Mentor.professor({}, {}).$promise.then(function (students) {
    $scope.students = students.mentor;
  }, function (error) {
    console.log(error.status);
  });
}]);