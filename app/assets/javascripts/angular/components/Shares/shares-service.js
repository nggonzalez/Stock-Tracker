var shares = angular.module('sharesService', ['ngResource']);
shares.factory('Shares', ['$resource', function ($resource) {
  return $resource('/api/shares/:id', { id: '@_id' }, {
    update: {
      method: 'PUT' // this method issues a PUT request
    },
    query: {
      method: 'GET',
      isArray: false
    }
  });
}]);