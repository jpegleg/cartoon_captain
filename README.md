# cartoon_captain
kubectl control systems observability prototype template

```
bash cartoon_captain.sh
```

The generated file in /var/www/html/cct.html has the output and the data sets are collected on disk in /opt/cctk/

This can be run on an interval to collect and diff kubernetes states.

The cct.html file can be shipped around and viewed in a web browser with auto refresh etc.

Known states (STATE-ID) values can be inserted into /opt/cctk/lookups.state with labels. Example:

```
e52318331cab, EAAS1beta <b style="color:green">HEALTHY</b>
1d0a6eaa2347, EAAS2beta <b style="color:blue">HEALTHY</b>
```

The only requirement for this lookups.state file structure is that each line starts with the STATE-ID followed by a comma, then the display string on that same line.

The file /opt/cctk/lookups.event file can be used similarly for the event data.

The ids are created from truncated BLAKE2 hashes of the kubectl output excluding the time column.

So when any new events occur, the EVENT-ID will change, and when any kubernetes pod, deployment, service, etc changes states or is recreated, the STATE-ID will change.

Note the events lines are also truncated to the 21st field. This will capture most events, but events with MESSAGE values longer than that will get truncted.

![cartoon_cap_1](https://carefuldata.com/images/cartoon_captain_1.png)
