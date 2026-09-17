#!/bin/bash
awk -F'"' '
$6 ~ /sqlmap/ {
    split($1, a, " ")
    ip = a[1]

    n = split($2, b, " ")
    method = b[1]
    path = b[2]
    for (i = 3; i < n; i++) path = path" "b[i]

    print ip","method","path
}
' "$1"
