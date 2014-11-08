var alerts = angular.module('alertsService', []);

alerts.factory('Alerts', ['$rootScope', function ($rootScope) {
  var Alerts = {
    alert: {},
    closeAlert: function () {
      this.alert = {};
    },
    showAlert: function (type, msg) {
      this.alert.type = type;
      this.alert.msg = msg;
    }
  };
  return Alerts;
}]);