var addFaq = angular.module('addQuestion', ['faqService', 'alertsService']);
addFaq.controller('AddQuestionCtrl', ['$scope', '$modalInstance', 'FAQ',
  'Alerts', 'args', function ($scope, $modalInstance, FAQ, Alerts, args) {
    $scope.add = true;

    $scope.question = {
      question: "",
      answer: [{p: ""}]
    };

    $scope.save = function () {
      // console.log($scope.question.text);
      FAQ.save({}, $scope.question).$promise.then(function (question) {
        Alerts.showAlert('success', 'Successfully saved question.');
        args[2].push(question);
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
