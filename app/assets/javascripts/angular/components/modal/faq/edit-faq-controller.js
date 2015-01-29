var addFaq = angular.module('editQuestion', ['faqService', 'alertsService']);
addFaq.controller('EditQuestionCtrl', ['$scope', '$modalInstance', 'FAQ',
  'Alerts', 'args', function ($scope, $modalInstance, FAQ, Alerts, args) {
    // Setup new offer
    // Send it
    $scope.question = args[2];

    $scope.save = function () {
      // console.log($scope.question.text);
      FAQ.update({}, $scope.question).$promise.then(function () {
        Alerts.showAlert('success', 'Successfully saved question.');
      }, function (error) {
        Alerts.showAlert('danger', 'Error saving question.');
      });
      $modalInstance.close($scope.question);
    };

    $scope.discard = function () {
      $modalInstance.dismiss('cancel');
    };

    $scope.addParagraph = function() {
      $scope.question.answer.push({p: ""});
    };

    $scope.deleteParagraph = function(index) {
      if($scope.question.answer.length > 1) {
        $scope.question.answer.splice(index, 1);
      }
    };

    $scope.moveParagraph = function(index, direction) {
      var ans = $scope.question.answer;
      if(direction == 1) { // move down one
        ans = ans.splice(index + 1, 0, ans.splice(index, 1)[0]);
      } else if(direction == -1) { // move up one
        ans = ans.splice(index - 1, 0, ans.splice(index, 1)[0]);
      }
    };
}]);
