var appCtrl = angular.module('app', ['studentService']);

appCtrl.controller('AppCtrl', ['$scope', 'Student', function ($scope, Student) {
  Student.get().$promise.then(function (student) {
    $scope.student = student.student;
  }, function (error) {
    console.log(error.status);
    $scope.student = null;
  });
}]);
