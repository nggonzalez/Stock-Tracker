var shares = angular.module('mentorService', ['ngResource']);
shares.factory('Mentor', ['$resource', function ($resource) {
  return $resource('/api/fellows/:type', { type: '@type' }, {
    professor: {
      method: 'GET',
      isArray: false,
      params: {type: 'prof'}
    },
    groups: {
      method: 'GET',
      params: {type: 'groups'}
    }
  });
}]);