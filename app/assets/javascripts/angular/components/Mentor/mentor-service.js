var shares = angular.module('mentorService', ['ngResource']);
shares.factory('Mentor', ['$resource', function ($resource) {
  return $resource('/api/fellows/:type/:student:team', { type: '@type' }, {
    professor: {
      method: 'GET',
      isArray: false,
      params: {type: 'prof'}
    },
    groups: {
      method: 'GET',
      params: {type: 'groups'}
    },
    shares: {
      method: 'GET',
      params: {type: 'shares', student: '@student'}
    },
    offers: {
      method: 'GET',
      params: {type: 'offers', team: '@team'}
    }
  });
}]);