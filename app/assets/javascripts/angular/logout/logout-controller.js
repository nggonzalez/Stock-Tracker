var logout = angular.module('logout', []);
logout.controller('LogoutCtrl', ['$state', function($state) {
  $state.reload();
  window.location = 'https://cs112stocktracker.herokuapp.com/';
}]);