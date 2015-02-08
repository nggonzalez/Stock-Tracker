var investment = angular.module('investmentService', ['ngResource']);
investment.factory('Investment', ['$resource', function ($resource) {
  return $resource('/api/investments', {}, {
    // professor: {
    //   method: 'GET',
    //   isArray: false,
    //   params: {type: 'prof'}
    // },
    // groups: {
    //   method: 'GET',
    //   params: {type: 'groups'}
    // },
    // shares: {
    //   method: 'GET',
    //   params: {type: 'shares', student: '@student'}
    // },
    // offers: {
    //   method: 'GET',
    //   params: {type: 'offers', team: '@team'}
    // }
  });
}]);