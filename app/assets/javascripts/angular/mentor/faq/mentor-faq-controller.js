var mentorFaq = angular.module('mentorFaq', ['faqService', 'alertsService', 'modalService']);
mentorFaq.controller('MentorFaqCtrl', ['$scope', 'FAQ', 'Alerts', 'Modal', function($scope, FAQ, Alerts, Modal) {
  $scope.admin = true;
  FAQ.get({}, {}).$promise.then(function (questions) {
    $scope.questions = questions.faqs;
    // console.log(questions);
  }, function (error) {
    Alerts.showAlert('danger', 'Error loading FAQ.');
  });

  $scope.addQuestion = function () {
    Modal.open('/templates/modals/editQuestion.html', 'AddQuestionCtrl', $scope.questions);
  };

  $scope.editQuestion = function (question) {
    Modal.open('/templates/modals/editQuestion.html', 'EditQuestionCtrl', question);
  };

  $scope.deleteQuestion = function(index, question) {
    FAQ.delete({}, {id: question.id}).$promise.then(function () {
      Alerts.showAlert('success', 'Successfully deleted question.');
      $scope.questions.splice(index, 1);
    }, function () {
      Alerts.showAlert('danger', 'Error deleting question.');
    });
  };
}]);