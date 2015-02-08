var modal = angular.module('modalService', ['sharesService', 'offersService', 'studentService', 'alertsService', 'teamService', 'mentorService', 'modalFaq', 'errorsService', 'reportModal', 'newInvestment']);
modal.factory('Modal', ['$modal', function ($modal) {
  var Modal = {
    open: function (modalTemplate, modalCtrl) {
      var args = arguments;
      var modalInstance = $modal.open({
        templateUrl: modalTemplate,
        controller: modalCtrl,
        resolve: {
          args: function() { return args; }
        }
      });

      modalInstance.result.then(function (selectedItem) {
        return selectedItem;
      }, function () {
        // $log.info('Modal dismissed at: ' + new Date());
      });
    }
  };

  return Modal;
}]);
