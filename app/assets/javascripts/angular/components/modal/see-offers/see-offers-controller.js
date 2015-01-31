
modal.controller('SeeOffersCtrl', ['$scope', '$modalInstance',
  'Mentor', 'Offers', 'args', 'Alerts', 'Error',
  function ($scope, $modalInstance, Mentor, Offers, args, Alerts, Error) {
    // Get shares
    console.log(args);
    var teamId = args[2];
    Mentor.offers({}, {team:teamId}).$promise.then(function (offers) {
      $scope.group = offers.group;
      $scope.open = offers.open;
      $scope.rejected = offers.rejected;
      console.log(offers, $scope.open, $scope.rejected)
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'offers', 'load open/rejected'));
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
        Alerts.showAlert('danger', Error.createMessage(error.status, 'offer', 'reset'));
      });
    };

    $scope.close = function () {
      $modalInstance.dismiss('cancel');
    };
}]);
