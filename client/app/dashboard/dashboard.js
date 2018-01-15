'use strict';

angular.module('myApp.dashboard', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/dashboard', {
    templateUrl: 'dashboard/dashboard.html',
    controller: 'DashboardCtrl'
  });
}])

.controller('DashboardCtrl', function($scope, $sce) {
  $scope.test1 = "http://www.youtube.com/embed/s03qez-6JMA?t=0h0m0s";
  $scope.test2 = "http://www.youtube.com/embed/UkWd0azv3fQ#t=2m30s";

    $scope.direct = function (data) {
      var q = data.query;
      window.location.href = "#!/document_retrive/" + q;
    }
});
