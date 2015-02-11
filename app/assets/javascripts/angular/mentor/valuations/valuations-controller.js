var valuations = angular.module('valuations', ['alertsService', 'errorsService', 'valuationsService']);
valuations.controller('MentorValuationCtrl', ['$scope', 'Valuation', 'Alerts', 'Error', function($scope, Valuation, Alerts, Error) {
  var makeGradesFloats = function (valuations) {
    for (var i = 0, length = valuations.valuation.length; i < length; i++) {
      var roundVals = valuations.valuation[i].valuations;
      for(var j = 0, valLength = roundVals.length; j < valLength; j++) {
        roundVals[j].grade = parseFloat(roundVals[j].grade, 10);
      }
    }
  };

  Valuation.get({}, {}).$promise.then(function (teamValuations) {
    $scope.valuationRounds = teamValuations.valuation;
    $scope.valuationRounds[0].active = true;
    $scope.pending = false;
    for (var i = 0, length = teamValuations.valuation.length; i < length; i++) {
      if(!teamValuations.valuation[i].live) {
        $scope.pending = true;
        break;
      }
    }
    makeGradesFloats(teamValuations);
    console.log(teamValuations);
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'teams and valuations', 'load'));
  });

  var updateValuations = function (valuations) {
    console.log(valuations);
    Valuation.update({}, valuations).$promise.then(function (teamValuations) {
      $scope.valuationRounds = teamValuations.valuation;
      $scope.valuationRounds[0].active = true;
      for (var i = 0, length = teamValuations.valuation.length; i < length; i--) {
        if(!teamValuations.valuation[i].live) {
          $scope.pending = true;
          break;
        }
      }
      makeGradesFloats(teamValuations);
      console.log(teamValuations);
      Alerts.showAlert('success', 'Successfully updated the grades within the valuation round.');
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'valuations', 'update'));
    });
  };

  $scope.saveValuations = function (valuations) {
    console.log(valuations);
    if(valuations.valuations[0].id != undefined) {
      updateValuations(valuations);
      return;
    }

    Valuation.save({}, valuations).$promise.then(function (teamValuations) {
      $scope.valuationRounds = teamValuations.valuation;
      $scope.valuationRounds[0].active = true;
      for (var i = 0, length = teamValuations.valuation.length; i < length; i--) {
        if(!teamValuations.valuation[i].live) {
          $scope.pending = true;
          break;
        }
      }
      makeGradesFloats(teamValuations);
      console.log(teamValuations);
      Alerts.showAlert('success', 'Successfully created a new valuation with the entered grades.');
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'valuations', 'save'));
    });

  };


  $scope.makeValuationsLive = function (valuations) {
    if (valuations.live) {
      return;
    }

    if(!confirm("Are you sure you want to make this valuation live? Once made live, grades cannot be editted.")) {
      return;
    }

    Valuation.live({}, valuations).$promise.then(function (teamValuations) {
      $scope.valuationRounds = teamValuations.valuation;
      $scope.valuationRounds[0].active = true;
      makeGradesFloats(teamValuations);
      console.log(teamValuations);
      Alerts.showAlert('success', 'Successfully made the valuations live.');
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'valuations', 'save'));
    });

    $scope.pending = false;
    valuations.live = true;
  };


  $scope.allHundreds = function (valuations) {
    vals = valuations.valuations
    for(var i = 0; i < vals.length; i++) {
      vals[i].grade = 100;
      console.log(vals[i]);
    }
    $scope.saveValuations(valuations);
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
          if(key != '$$hashKey' && key != 'grade' && key != 'id') {
            val[key] = valuations[i][key];
          }
        }
      }
      newValuations.push(val);
    }
    $scope.valuationRounds.push({round: roundId, valuations: newValuations});
    $scope.valuationRounds[$scope.valuationRounds.length - 1].active = true;
    console.log(newValuations);
  };
}]);