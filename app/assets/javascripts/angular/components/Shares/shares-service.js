var shares = angular.module('sharesService', ['ngResource']);
shares.factory('Shares', ['$resource', function ($resource) {
  return $resource('/api/shares/:employee/:team', { employee: '@employee' }, {
    update: {
      method: 'PUT' // this method issues a PUT request
    },
    query: {
      method: 'GET',
      isArray: false
    },
    getEmployeeShares: {
      method: 'GET',
      params: {team: '@team'}
    },
  });
}]);