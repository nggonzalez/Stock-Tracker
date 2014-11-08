var groups = angular.module('groups', ['mentorService', 'alertsService']);
groups.controller('GroupsCtrl', ['$scope', 'Mentor', 'Alerts', function ($scope, Mentor, Alerts) {
  Mentor.groups({}, {}).$promise.then(function (groups) {
    $scope.groups = groups.mentor;
  }, function (error) {
    Alerts.showAlert('danger', 'Error loading groups.');
  });
}]);