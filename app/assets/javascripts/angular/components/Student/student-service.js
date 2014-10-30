var student = angular.module('studentService', ['ngResource']);
student.factory('Student', ['$resource', function ($resource) {
  return $resource('/api/student/:all', {all: '@all'}, {
    update: {
      method: 'PUT' // this method issues a PUT request
    },
    query: {
      method: 'GET',
      params: {all: 'all'},
      isArray: false
    }
  });
}]);
