var equity = angular.module('equity', ['nvd3ChartDirectives', 'sharesService']);
equity.controller('EquityCtrl', ['$scope', 'Shares', function ($scope, Shares) {
  this.dateTicks = function () {
    return function (d) {
      console.log(d);
      return new Date(d);
    };
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

  Shares.query().$promise.then(function (sharesData) {
    console.log(sharesData);
    $scope.sharesData = sharesData;
    var shares = sharesData.shares,
      sharesLength = shares.length,
      companies = {},
      companyId,
      i;

    for (i = 0; i < sharesLength; i++) {
      shares[i].open = true;
      companyId = shares[i].company;
      if (!companies[companyId]) {
        companies[companyId] = {};
        companies[companyId].open = true;
        companies[companyId].aggregateDailyIncrease = 0;
        companies[companyId].aggregateTotalShares = 0;
        companies[companyId].aggregateEarnedShares = 0;
        companies[companyId].company = shares[i].company;
        companies[companyId].offers = [];
      }
      companies[shares[i].company].offers.push(shares[i]);
      companies[companyId].aggregateDailyIncrease += shares[i].dailyIncrease;
      companies[companyId].aggregateTotalShares = shares[i].totalShares;
      companies[companyId].aggregateEarnedShares = shares[i].earnedShares;
    }
    var companyArray = [];
    for(var key in companies) {
      if(companies.hasOwnProperty(key)) {
        companyArray.push(companies[key]);
      }
    }

    $scope.companies = companyArray;

  }, function (error) {
    console.log(error.status);
  });

}]);