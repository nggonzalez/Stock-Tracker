var equity = angular.module('equity', ['nvd3ChartDirectives', 'sharesService']);
equity.controller('EquityCtrl', ['Shares', function (Shares) {
  this.dateTicks = function () {
    return function (d) {
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

  Shares.get().$promise.then(function(sharesData) {
    console.log(sharesData);
    this.sharesData = sharesData;
  }, function (error) {
    console.log(error.status);
  });

}]);