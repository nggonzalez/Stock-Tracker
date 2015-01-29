var FAQ = angular.module('faqService', ['ngResource']);
FAQ.factory('FAQ', ['$resource', function ($resource) {
  return $resource('/api/faq/:id', {}, {
    'update': {method:'PATCH'},
    'delete': {method: 'DELETE', params: {id: '@id'}}
  });
}]);