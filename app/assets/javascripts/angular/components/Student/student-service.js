var student = angular.module('studentService', ['ngResource']);
student.factory('Student', ['$resource', function ($resource) {
  return $resource('/api/students/:id', { id: '@_id' }, {
    update: {
      method: 'PUT' // this method issues a PUT request
    }
  });
}]);