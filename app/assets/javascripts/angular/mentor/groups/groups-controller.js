var groups = angular.module('groups', ['mentorService', 'alertsService', 'modalService']);
groups.controller('GroupsCtrl', ['$scope', 'Mentor', 'Alerts', 'Modal', function ($scope, Mentor, Alerts, Modal) {
  Mentor.groups({}, {}).$promise.then(function (groups) {
    $scope.groups = groups.mentor;
    console.log(groups);
  }, function (error) {
    Alerts.showAlert('danger', 'Error loading groups.');
  });

  $scope.seeShares = function (student) {
    Modal.open('/templates/modals/studentshares.html', 'StudentSharesCtrl', -1, student.id);
  };

  $scope.seeOffers = function (team) {
    Modal.open('/templates/modals/seeoffers.html', 'SeeOffersCtrl', team, undefined);
  };
}]);