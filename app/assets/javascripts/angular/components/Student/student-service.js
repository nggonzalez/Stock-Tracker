var student = angular.module('studentService', ['ngResource']);
student.factory('Student', ['$resource', function ($resource) {
  return $resource('/api/student', {}, {
    update: {
      method: 'PUT' // this method issues a PUT request
    }
  });
}]);
