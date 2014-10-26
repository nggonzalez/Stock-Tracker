var equity = angular.module('equity', ['nvd3ChartDirectives', 'sharesService']);
equity.controller('EquityCtrl', ['$scope', 'Shares', function ($scope, Shares) {
  this.dateTicks = function () {
    return function (d) {
      console.log(d);
      return d3.time.format('%x')(new Date(d));
    }
  };

  // Student.get({id: 'ngg23'}).$promise.then(function(student) {
  //   console.log(student.student);
  // }, function (error) {
  //   console.log('error');
  // });

  // Student.get({id: 'ngg2'}).$promise.then(function(student) {
  //   console.log(student)
  // }, function (error) {
  //   console.log(error.status);
  // });

  Shares.query().$promise.then(function(sharesData) {
    console.log(sharesData);
    $scope.sharesData = sharesData;
  }, function (error) {
    console.log(error.status);
  });

}]);