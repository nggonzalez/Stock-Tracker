var valuations = angular.module('valuations', ['alertsService', 'errorsService']);
valuations.controller('MentorValuationCtrl', ['$scope', function($scope) {
  $scope.valuations = [{round: 0, live: true, teams: [{}] }, {round: 1, live: false, teams: [{}] }];
}]);