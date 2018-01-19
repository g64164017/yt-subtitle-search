'use strict';

angular.module('myApp.document_retrive', ['ngRoute'])

.config(['$routeProvider', function($routeProvider) {
  $routeProvider.when('/document_retrive/:q', {
    templateUrl: 'document_retrive/document_retrive.html',
    controller: 'DocRetriveCtrl'
  });
}])

.controller('DocRetriveCtrl', function($scope, $routeParams, $sce, DocRetriveService) {
    var data = $routeParams.q

    DocRetriveService.getDocumentRetrive(data).then(function (response) {
        $scope.data = {};
        var doc = response.data;
        for(var i=0; i < doc.length; i++){
            var start = doc[i].time_start;
            console.log(start);
            start = start.split(":");
            start = (parseInt(start[0])*3600) + (parseInt(start[1])*60) + parseInt(start[2]);
            doc[i].url = "http://www.youtube.com/embed/" + doc[i].video_id + "?start=" + start;
        }
        console.log(doc)
        $scope.data.documents = doc
    })

    $scope.trustSrc = function (src) {
        return $sce.trustAsResourceUrl(src);
    }

    $scope.search = function (data) {
      DocRetriveService.getDocumentRetrive(data.query).then(function (response) {
        $scope.data = {};
        var doc = response.data;
        for(var i=0; i < doc.length; i++){
            doc[i].url = "http://www.youtube.com/embed/" + doc[i].url.substring(17, doc[i].url.length)
        }
        console.log(doc)
        $scope.data.documents = doc
      })
    }
})
.factory("DocRetriveService", function ($http, configuration) {
    return {
      getDocumentRetrive: function (q) {
          var url = configuration.url + "/search?q=" + q.toString();
          return $http.post(url);
      }
    }
});
