var faq = angular.module('faq', ['faqService', 'alertsService', 'errorsService']);
faq.controller('FaqCtrl', ['$scope', 'FAQ', 'Alerts', 'Errors', function($scope, FAQ, Alerts, Errors) {
  FAQ.get({}, {}).$promise.then(function (questions) {
    $scope.questions = questions.faqs;
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'questions', 'load'));
  });
}]);