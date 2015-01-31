var reportDirective = angular.module('reportDirective', ['errorsService', 'modalService']);

reportDirective.directive('report', ['Error', 'Modal', function (Error, Modal) {
  return {
    restrict: 'E',
    replace: true,
    scope: {},
    templateUrl: '/templates/directives/report.html',
    link: function(scope) {
      scope.report = function() {
        Modal.open('/templates/modals/reportBug.html', 'ReportBugCtrl', Error.retrieveRecentError());
      };
    }
  };
}]);
