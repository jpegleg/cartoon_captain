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

