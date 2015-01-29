
modal.controller('SeeOffersCtrl', ['$scope', '$modalInstance',
  'Mentor', 'Offers', 'args', 'Alerts',
  function ($scope, $modalInstance, Mentor, Offers, args, Alerts) {
    // Get shares
    console.log(args);
    var teamId = args[2];
    Mentor.offers({}, {team:teamId}).$promise.then(function (offers) {
      $scope.group = offers.group;
      $scope.open = offers.open;
      $scope.rejected = offers.rejected;
      console.log(offers, $scope.open, $scope.rejected)
    }, function (error) {
      Alerts.showAlert('danger', 'Error loading offers.');
    });

    $scope.resetOffer = function (index, offer) {
      if(index < $scope.open.length && $scope.open[index].id == offer.id) {
        $scope.open.splice(index, 1);
      } else {
        $scope.rejected.splice(index, 1);
      }
      Offers.delete({}, offer).$promise.then(function () {
        Alerts.showAlert('success', 'Successfully reset the offer.');
      }, function (error) {
        Alerts.showAlert('danger', 'Error reseting offer.');
      });
    };

    $scope.close = function () {
      $modalInstance.dismiss('cancel');
    };
}]);
