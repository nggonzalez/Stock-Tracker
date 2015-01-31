var mentorFaq = angular.module('mentorFaq', ['faqService', 'alertsService', 'modalService', 'errorsService']);
mentorFaq.controller('MentorFaqCtrl', ['$scope', 'FAQ', 'Alerts', 'Modal', 'Error', function($scope, FAQ, Alerts, Modal, Error) {
  $scope.admin = true;
  FAQ.get({}, {}).$promise.then(function (questions) {
    $scope.questions = questions.faqs;
  }, function (error) {
    Alerts.showAlert('danger', Error.createMessage(error.status, 'questions', 'load'));
  });

  $scope.addQuestion = function () {
    Modal.open('/templates/modals/editQuestion.html', 'AddQuestionCtrl', $scope.questions);
  };

  $scope.editQuestion = function (question) {
    Modal.open('/templates/modals/editQuestion.html', 'EditQuestionCtrl', question);
  };

  $scope.deleteQuestion = function(index, question) {
    FAQ.delete({}, {id: question.id}).$promise.then(function () {
      Alerts.showAlert('success', 'Successfully deleted question:\n' + question.question);
      $scope.questions.splice(index, 1);
    }, function (error) {
      Alerts.showAlert('danger', Error.createMessage(error.status, 'question', 'delete'));
    });
  };
}]);