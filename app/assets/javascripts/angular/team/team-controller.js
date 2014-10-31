var team = angular.module('team', ['teamService', 'modalService']);
team.controller('TeamCtrl', ['$scope', 'Team', 'Modal', function ($scope, Team, Modal) {
  var teamId = undefined;
  Team.get().$promise.then(function (teamData) {
    teamId = teamData.currentCompany.companyId;
    $scope.currentCompany = teamData.currentCompany;
    $scope.studentName = teamData.student;
    $scope.previousCompanies = teamData.previousCompanies;
  }, function (error) {
    console.log(error.status);
  });

  $scope.admin = $scope.$parent.student.admin;

  $scope.recruitEmployee = function () {
    Modal.open('templates/modals/newoffer.html', 'SendOfferCtrl', teamId, undefined);
  };

  $scope.seeShares = function (employee) {
    Modal.open('templates/modals/seeshares.html', 'SeeSharesCtrl', teamId, employee.id);
  };
}]);
