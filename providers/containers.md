## ManageIQ Container Providers

See ![instructions](/providers/openshift) for installing an OpenShift origin container provider.

### Containers Smart State Analysis

Current architecture diagram:

![container smart state analysis diagram](/images/containers-ssa.png "container smart state analysis")

[Smart State Analysis demo with technical comments](https://www.youtube.com/watch?v=Uc5kTSdVNZA "Smart State Analysis demo with technical comments")

### Containers Metrics

Current architecture diagram:

![container metrics diagram](/images/containers-metrics.png "container metrics")

For the future it is planned for Kubelet to update statistics in the Master API Server and Heapster will collect the metrics from there.

