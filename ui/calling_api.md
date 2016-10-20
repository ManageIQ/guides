### Calling the API

Moving forward we want to use the API from the UI.

To interface with the API, please observe the following best practice:

**Do**: In your Angular controller or factory, inject the API service.

**Don't** Use the Rails controller.

This is possible by an API token that is created in addition to a normal session on user login.

Injection example:

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

