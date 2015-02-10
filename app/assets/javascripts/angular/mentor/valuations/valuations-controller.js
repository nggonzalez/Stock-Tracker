var valuations = angular.module('valuations', ['alertsService', 'errorsService', 'valuationsService']);
valuations.controller('MentorValuationCtrl', ['$scope', 'Valuation', function($scope, Valuation) {
  Valuation.get({}, {}).$promise.then(function (teamValuations) {
    $scope.valuationRounds = teamValuations.valuation;
    $scope.valuationRounds[0].active = true;
    $scope.pending = false;
    for (var i = 0, length = teamValuations.valuation.length; i < length; i--) {
      if(!teamValuations.valuation[i].live) {
        $scope.pending = true;
        break;
      }
    }
    console.log(teamValuations);
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'teams and valuations', 'load'));
  });


  $scope.saveValuations = function (valuations) {
    console.log(valuations);
  };

  $scope.makeValuationsLive = function (valuations) {
    if (valuations.live) {
      return;
    }

    if(!confirm("Are you sure you want to make this valuation live? Once made live, grades cannot be editted.")) {
      return;
    }

    $scope.pending = false;
    valuations.live = true;
  };


  $scope.newValuationRound = function() {
    $scope.pending = true;
    var newValuations = [],
        numTeams = $scope.valuationRounds[0].valuations.length,
        valuations = $scope.valuationRounds[$scope.valuationRounds.length - 1].valuations,
        roundId = $scope.valuationRounds.length;
    for(var i = 0; i < numTeams; i++) {
      var val = {}
      for (var key in valuations[i]) {
        if (valuations[i].hasOwnProperty(key)) {
          if(key != '$$hashKey' || key != 'grade') {
            val[key] = valuations[i][key];
          }
        }
      }
      newValuations.push(val);
    }
    $scope.valuationRounds.push({round: roundId, valuations: newValuations});
    $scope.valuationRounds[$scope.valuationRounds.length - 1].active = true;
  };
}]);