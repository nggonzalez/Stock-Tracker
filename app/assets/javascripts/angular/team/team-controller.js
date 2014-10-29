var team = angular.module('team', ['teamService']);
team.controller('TeamCtrl', ['$scope', 'Team', function ($scope, Team) {
  Team.get().$promise.then(function (teamData) {
    $scope.currentCompany = teamData.currentCompany;
    $scope.student = teamData.student;
    $scope.previousCompanies = teamData.previousCompanies;
  }, function (error) {
    console.log(error.status);
  });

  $scope.student = $scope.$parent.student;
}]);
