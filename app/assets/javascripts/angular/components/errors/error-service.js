var errors = angular.module('errorsService', ['ui.router']);

errors.factory('Error', ['$state', function ($state) {
  var _recentError = {
    errorCode: undefined,
    state: undefined,
    model: undefined,
    action: undefined
  };

  var errorTypes = {
    401: 'Unauthorized. If you think this is a mistake, please report the error.',
    404: 'Not Found.',
    422: 'Unprocessable Entity. Check that you have entered all valid entries into the form.',
    500: 'Internal Server Error - PLEASE REPORT!'
  };

  var storeError =function(status, model, action) {
    _recentError.errorCode = status;
    _recentError.state = $state.current.name;
    _recentError.model = model;
    _recentError.action = action;
  };

  var processStatus = function(status) {
      return errorTypes[status] || 'Unknown Error.';
  };

  var Error = {
    createMessage: function(status, model, action) {
      storeError(status, model, action);
      return 'Failed to ' + action + ' ' + model +'.\n' + status + ' error: ' + processStatus(status);
    },
    retrieveRecentError: function() {
      return _recentError;
    }
  };
  return Error;
}]);