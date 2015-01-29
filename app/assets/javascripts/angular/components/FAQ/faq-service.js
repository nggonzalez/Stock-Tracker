var FAQ = angular.module('faqService', ['ngResource']);
FAQ.factory('FAQ', ['$resource', function ($resource) {
  return $resource('/api/faq', {}, {
    'update': {method:'PATCH'}
  });
}]);