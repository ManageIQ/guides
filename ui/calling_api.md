### Calling the API

Moving forward we want to use the API from the UI, not the other Rails
controller where possible. To do so when user is logged in besides normal
session there's also the API token created.

To access the API there's a Angular service available.

To use it you have to inject the "API" into the Angular controller:
```
ManageIQ.angular.app.controller('arbitrationProfileFormController', ['$scope', '$location', 'arbitrationProfileFormId', 'miqService', 'postService', 'API', 'arbitrationProfileDataFactory', function($scope, $location, arbitrationProfileFormId, miqService, postService, API, arbitrationProfileDataFactory) {
```

then you can use the API. GET example:
```
API.get(url).then(function(response) {
  $scope.cloud_subnets   = response.cloud_subnets;
  $scope.security_groups = response.security_groups;
  $scope._cloud_subnet = _.find($scope.cloud_subnets, {id: $scope.arbitrationProfileModel.cloud_subnet_id})
  $scope._security_group = _.find($scope.security_groups, {id: $scope.arbitrationProfileModel.security_group_id})
})
```

POST example:
```
API.post(url, {"action" : "create", "resource" : resource}).then(function (response) {
  'use strict';
  $scope.deployInProgress = false;
  $scope.deployComplete = true;
  $scope.deployFailed = response.error !== undefined;
  if (response.error) {
    if (response.error.message) {
      $scope.deployFailureMessage = response.error.message;
    }
    else {
      $scope.deployFailureMessage = __("An unknown error has occurred.");
    }
  }
});
```

