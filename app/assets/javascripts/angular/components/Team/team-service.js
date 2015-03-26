var team = angular.module('teamService', ['ngResource']);
team.factory('Team', ['$resource', function ($resource) {
  return $resource('/api/teams/:type/:id', { id: '@id' }, {
    update: {
      method: 'PUT' // this method issues a PUT request
    },
    shares: {
      method: 'GET',
      params: {type: 'shares', id: '@id'}
    },
    dissolve: {
      method: 'DELETE',
      params: {type: 'dissolve', id: '@id'}
    }
  });
}]);
