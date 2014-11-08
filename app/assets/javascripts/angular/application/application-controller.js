var appCtrl = angular.module('app', ['studentService', 'alertsService']);

appCtrl.controller('AppCtrl', ['$scope', 'Student', 'Alerts',
  function ($scope, Student, Alerts) {
    Student.get().$promise.then(function (student) {
      $scope.student = student.student;
    }, function (error) {
      if(error.status !== 404) {
        Alerts.showAlert('danger', 'Could not load your information, please refresh the page.');
      }
      $scope.student = null;
    });
}]);
