var equity = angular.module('equity', ['nvd3ChartDirectives', 'sharesService', 'alertsService', 'errorsService']);
equity.controller('EquityCtrl', ['$scope', 'Shares', 'Alerts', 'Error', function ($scope, Shares, Alerts, Errors) {
  $scope.xAxisTickFormatFunction = function(){
    return function(d) {
      var startDate = new Date(2015, 1, 12);
      if(d % 1 === 0) {
        return d3.time.format('%x')(new Date(startDate.setDate(startDate.getDate() + d)));//uncomment for date format
      }
      return;
    };
  };

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
    Alerts.showAlert('danger', Error.createMessage(error.status, 'shares', 'load'));
  });

}]);
