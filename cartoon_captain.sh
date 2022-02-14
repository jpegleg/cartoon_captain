#!/usr/bin/env bash
which kubectl || exit 1
kubectl get nodes || exit 1
ttime=$(date +%Y%m%d%H%M%S)
mkdir -p /opt/cctk/workspace 2>/dev/null
touch /opt/cctk/workspace/current.state
touch /opt/cctk/workspace/diff.current
touch /opt/cctk/workspace/previous.state
touch /opt/cctk/workspace/previous.events
touch /opt/cctk/lookups.state
touch /opt/cctk/lookups.events
cp /opt/cctk/workspace/current.state /opt/cctk/workspace/previous.state
kubectl get all -A > /opt/cctk/workspace/current.state
cat /opt/cctk/workspace/current.state | awk '{print $1,$2,$3,$4,$5}' > /opt/cctk/workspace/current.state.timeless
kubectl get events -A > /opt/cctk/workspace/events.state
shash=$(b2sum /opt/cctk/workspace/current.state.timeless | cut -d' ' -f1 | cut -c1-12)
echo "🍻 STATE-ID $shash" > /opt/cctk/workspace/state.hash
dhash=$(b2sum /opt/cctk/workspace/events.state | cut -d ' ' -f1 | cut -c1-12)
echo "🍃 EVENT-ID $dhash" > /opt/cctk/workspace/events.hash
echo "<h2>$(grep $shash /opt/cctk/lookups.state | cut -d',' -f2)</h2>" > /opt/cctk/workspace/state.display
echo "<h2>$(grep $dhash /opt/cctk/lookups.events | cut -d',' -f2)</h2>" > /opt/cctk/workspace/events.display
mdris="$ttime$shash$dhash"
sed 'i/\n/\n</br>' /opt/cctk/workspace/current.state > /opt/cctk/workspace/catalog_$mdris.dat
grep -v "^/$" /opt/cctk/workspace/catalog_$mdris.dat > /opt/cctk/workspace/catalog.skip
cp /opt/cctk/workspace/catalog.skip /opt/cctk/workspace/catalog_$mdris.dat
sed 'i/\n/\n</br>' /opt/cctk/workspace/events.state > /opt/cctk/workspace/events_$mdris.dat
grep -v "^/$" /opt/cctk/workspace/events_$mdris.dat > /opt/cctk/workspace/events.skip
cp /opt/cctk/workspace/events.skip /opt/cctk/workspace/events_$mdris.dat
diff /opt/cctk/workspace/previous.state /opt/cctk/workspace/catalog_$mdris.dat > /opt/cctk/workspace/diff_$mdris.dat
sed 'i/\n/\n</br>' /opt/cctk/workspace/diff_$mdris.dat > /opt/cctk/workspace/diff.current
echo "<html>" > /opt/cctk/workspace/cct.html
echo >> /opt/cctk/workspace/cct.html
cat /opt/cctk/stylefile.in  >> /opt/cctk/workspace/cct.html
echo "<h1>OBSERVE OBEY CARTOON WORLD</h1>" >> /opt/cctk/workspace/cct.html
echo "🐳 $(date +%Y%m%d%H%M%S%N)" >> /opt/cctk/workspace/cct.html
cat /opt/cctk/workspace/*.hash >> /opt/cctk/workspace/cct.html
echo "</br>" >> /opt/cctk/workspace/cct.html
cat /opt/cctk/workspace/*.display >> /opt/cctk/workspace/cct.html
cat /opt/cctk/stylefile.close >> /opt/cctk/workspace/cct.html
echo "</br></br>kubectl get all -A</br></br>" >> /opt/cctk/workspace/cct.html
cat /opt/cctk/workspace/catalog_$mdris.dat >> /opt/cctk/workspace/cct.html
echo "</br>" >> /opt/cctk/workspace/cct.html
echo "</br></br>kubectl get events -A</br></br>" >> /opt/cctk/workspace/cct.html
cat /opt/cctk/workspace/events_$mdris.dat >> /opt/cctk/workspace/cct.html
echo "</html>" >> /opt/cctk/workspace/cct.html
cp /opt/cctk/workspace/cct.html /var/www/html/
