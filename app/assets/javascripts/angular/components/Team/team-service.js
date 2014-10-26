var team = angular.module('teamService', ['ngResource']);
team.factory('Team', ['$resource', function ($resource) {
  return $resource('/api/teams/:id', { id: '@_id' }, {
    update: {
      method: 'PUT' // this method issues a PUT request
    }
  });
}]);