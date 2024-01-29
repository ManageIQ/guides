# installing vmware simulator

```bash
cd ~/go/
git clone https://github.com/kbrock/govmomi
cd govmomi
git remote add upstream  https://github.com/vmware/govmomi
git checkout miq_counters_kb
# client
pushd govc ; make clean && make && make install ; popd
# server
pushd vcsim ; make clean && make && make install ; popd
ln -s ~/go/bin/vcsim ~/bin # or /usr/local/bin
ln -s ~/go/bin/govc ~/bin  # or /usr/local/bin
```

# creating simulator provider

```bash
echo "127.0.0.1 vc91" > /etc/hosts

# run temporary simulator 
vcsim -username root -password vmware -app 2 -cluster 2 -dc 1 -ds 2 -folder 2 \
      -host 2 -nsx 2 -pg 2 -pg-nsx 2 -pod 2 -pool 1 -standalone-host 2 -vm 2 \
      -l vc91:9191 &

export GOVC_URL=https://root:vmware@vc91:9191/sdk GOVC_INSECURE=true
govc object.save -d my-vcenter
# stop stop temporary simulator
kill %1 # or fg ; control-c
```

# adding historicals

```xml
<!--
  edit my-vcenter/0009-PerformanceManager-PerfMgr.xml
  find nistoricalInterval
  -->
  <propSet>
    <name>historicalInterval</name>
    <val xmlns:XMLSchema-instance="http://www.w3.org/2001/XMLSchema-instance" XMLSchema-instance:type="ArrayOfPerfInterval">
      <PerfInterval>
        <key>1</key>,
        <samplingPeriod>300</samplingPeriod>
        <length>86400</length>
        <name>Past Day</name>
        <level>1</level>
        <enabled>true</enabled>
      </PerfInterval>
      <PerfInterval>
        <key>2</key>
        <samplingPeriod>1800</samplingPeriod>
        <length>604800</length>
        <name>Past Week</name>
        <level>1</level>
        <enabled>true</enabled>
      </PerfInterval>
      <PerfInterval>
        <key>3</key>
        <samplingPeriod>7200</samplingPeriod>
        <length>2592000</length>
        <name>Past Month</name>
        <level>1</level>
        <enabled>true</enabled>
      </PerfInterval>
      <PerfInterval>
        <key>4</key>
        <samplingPeriod>86400</samplingPeriod>
        <length>31536000</length>
        <name>Past Year</name>
        <level>1</level>
        <enabled>true</enabled>
      </PerfInterval>
    </val>
  </propSet>
```
# better editing of historicals

TODO: please figure out a way to add historicals without editing the files.
That way we can just use the vmware simulator container

```bash
  govc object.collect -s -dump PerformanceManager:PerfMgr historicalInterval
  govc metric.interval.info

  govc metric.interval.change

  # this one has a default (not sure if related or not)
  govc object.collect -s -dump PerformanceManager:PerfMgr perfCounter
```

# run

```bash
# I dumped to a local directory to add historical capture support
vcsim -username root -password vmware -load my-vcenter -l vc91:9191
```
