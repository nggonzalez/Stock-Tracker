var groups = angular.module('groups', ['mentorService', 'alertsService', 'modalService', 'errorsService']);
groups.controller('GroupsCtrl', ['$scope', 'Mentor', 'Alerts', 'Modal', 'Error', function ($scope, Mentor, Alerts, Modal, Error) {
  Mentor.groups({}, {}).$promise.then(function (groups) {
    $scope.groups = groups.mentor;
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'mentor\'s teams', 'load'));
  });

  $scope.seeShares = function (student) {
    Modal.open('/templates/modals/studentshares.html', 'StudentSharesCtrl', -1, student.id);
  };

  $scope.seeOffers = function (team) {
    Modal.open('/templates/modals/seeoffers.html', 'SeeOffersCtrl', team, undefined);
  };
}]);