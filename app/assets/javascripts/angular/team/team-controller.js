var team = angular.module('team', ['teamService', 'modalService', 'alertsService']);
team.controller('TeamCtrl', ['$scope', 'Team', 'Modal', 'Alerts', function ($scope, Team, Modal, Alerts) {
  var teamId = undefined;
  Team.get().$promise.then(function (teamData) {
    teamId = teamData.currentCompany.companyId;
    $scope.currentCompany = teamData.currentCompany;
    $scope.studentName = teamData.student;
    $scope.previousCompanies = teamData.previousCompanies;
  }, function (error) {
    Alerts.showAlert('danger', 'Error loading team data.');
  });

  $scope.admin = $scope.$parent.student.admin;

  $scope.recruitEmployee = function () {
    Modal.open('templates/modals/newoffer.html', 'SendOfferCtrl', teamId, undefined);
  };

  $scope.seeShares = function (employee) {
    Modal.open('templates/modals/seeshares.html', 'SeeSharesCtrl', teamId, employee.id);
  };
}]);
