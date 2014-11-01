var equity = angular.module('equity', ['nvd3ChartDirectives', 'sharesService']);
equity.controller('EquityCtrl', ['$scope', 'Shares', function ($scope, Shares) {
  // $scope.xAttributeFunction = function() {
  //   var minDate = new Date(2014, 10, 27);
  //   var maxDate = new Date(2014, 12, 11);
  //   return function(d){
  //     return d3.time.scale().domain([minDate, maxDate]).range([0, d]);
  //   };
  // };
  // var xAxisTickMarks = [];
  // var currDate = new Date(2014, 10, 27);
  // var maxDate = new Date();
  // while(currDate < maxDate) {
  //   xAxisTickMarks.push(currDate);
  //   currDate.setDate(currDate.getDate() + 1);
  // }
  // $scope.xAxisTickMarks = xAxisTickMarks;

  $scope.xAxisTickFormatFunction = function(){
    return function(d) {
      var startDate = new Date(2014, 9, 27);
      if(d % 1 === 0) {
        console.log(d);
        return d3.time.format('%x')(new Date(startDate.setDate(startDate.getDate() + d)));//uncomment for date format
      }
      return;
    };
  };

  // $scope.xAxisTickFormatFunction = function(){
  //   return function(d){
  //     console.log(d);
  //     return d3.format('%x')(new Date(d)); //uncomment for date format
  //   };
  // };

  Shares.get().$promise.then(function (sharesData) {
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
