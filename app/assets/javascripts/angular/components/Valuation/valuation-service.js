var valuation = angular.module('valuationsService', ['ngResource']);
valuation.factory('Valuation', ['$resource', function ($resource) {
  return $resource('/api/valuation/:action', {}, {
    save: {
      method: 'POST',
      params: {action: 'save'}
    },
    live: {
      method: 'POST',
      params: {action: 'live'}
    },
    update: {
      method: 'POST',
      params: {action: 'update'}
    }
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