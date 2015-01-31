var reportModal = angular.module('reportModal', ['alertsService', 'errorsService']);
reportModal.controller('ReportBugCtrl', ['$scope', '$http', '$modalInstance',
  'Alerts', 'args', 'Error', function ($scope, $http, $modalInstance, Alerts, args, Error) {

    $scope.feedback = {};

    $scope.discard = function () {
      $modalInstance.dismiss('cancel');
    };

    $scope.sendReport = function () {
      console.log($scope.feedback.text, args[2]);
      var report = {
        error: args[2],
        feedback: $scope.feedback.text
      };

      $http.post('/api/report/bug', report).success(function() {
        Alerts.showAlert('success', 'Successfully reported error.');
      }).error(function(error) {
        Alerts.showAlert('danger', Error.createMessage(error.status, 'report', 'send'));
      });
      $modalInstance.close();
    };
}]);
