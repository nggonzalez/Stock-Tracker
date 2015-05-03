var mentorCSV = angular.module('mentorCSV', ['alertsService', 'errorsService']);
mentorCSV.controller('MentorCSVCtrl', ['$scope', function($scope) {

  $scope.downloadCSV = function() {
    window.location.assign('/api/fellows/csv');
  };

}]);