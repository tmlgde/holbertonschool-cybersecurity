#!/bin/bash
TRI=$(awk '$9 == 404 || $9 == 403 { print $1}' "$1" | sort | uniq -c | sort -nr |head -5)

cat << EOF > "$2"
<html><body>
<h1>Security Report</h1>
<table>
<tr><th>IP</th><th>Count</th></tr>
EOF
echo "$TRI" | while read count ip; do
	echo "<tr><td>$ip</td><td>$count</td></tr>" >> "$2"
done
cat << EOF >> "$2"
</table>
</body>
</html>
EOF
