var groups = angular.module('groups', ['mentorService']);
groups.controller('GroupsCtrl', ['$scope', 'Mentor', function ($scope, Mentor) {
  Mentor.groups({}, {}).$promise.then(function (groups) {
    $scope.groups = groups.mentor;
  }, function (error) {
    console.log(error.status);
  });
}]);