var team = angular.module('team', ['teamService', 'modalService']);
team.controller('TeamCtrl', ['$scope', 'Team', 'Modal', function ($scope, Team, Modal) {
  Team.get().$promise.then(function (teamData) {
    $scope.currentCompany = teamData.currentCompany;
    $scope.student = teamData.student;
    $scope.previousCompanies = teamData.previousCompanies;
  }, function (error) {
    console.log(error.status);
  });

  $scope.admin = $scope.$parent.student.admin;

  $scope.recruitEmployee = function () {
    Modal.open('templates/modals/newoffer.html', 'SendOfferCtrl');
  };

  $scope.seeShares = function () {
    Modal.open('templates/modals/seeshares.html', 'SeeSharesCtrl');
  };
}]);
