var faq = angular.module('faq', ['faqService', 'alertsService']);
faq.controller('FaqCtrl', ['$scope', 'FAQ', 'Alerts', function($scope, FAQ, Alerts) {
  FAQ.get({}, {}).$promise.then(function (questions) {
    $scope.questions = questions.faqs;
  }, function (error) {
    Alerts.showAlert('danger', 'Error loading FAQ.');
  });
}]);