var addFaq = angular.module('addQuestion', ['faqService', 'alertsService']);
addFaq.controller('AddQuestionCtrl', ['$scope', '$modalInstance', 'FAQ',
  'Alerts', function ($scope, $modalInstance, FAQ, Alerts) {
    // Setup new offer
    // Send it
    $scope.question = {
      text: "",
      answer: [{p: ""}]
    };

    $scope.save = function () {
      // console.log($scope.question.text);
      FAQ.save({}, $scope.question).$promise.then(function () {
        Alerts.showAlert('success', 'Successfully saved question.');
      }, function (error) {
        Alerts.showAlert('danger', 'Error sending offer.');
      });
      $modalInstance.close($scope.question);
    };

    $scope.discard = function () {
      $modalInstance.dismiss('cancel');
    };

    $scope.addParagraph = function() {
      $scope.question.answer.push({p: ""});
    }

    $scope.deleteParagraph = function(index) {
      $scope.question.answer.splice(index, 1);
    }
}]);
