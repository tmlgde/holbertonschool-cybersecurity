#!/bin/bash
echo "=== Apache Recovery ==="
echo ""
echo "Configuration test..."
if sudo apache2ctl configtest 2>&1 | grep -q "Syntax OK"; then
    echo "  Syntax: OK"
else
    echo "  Syntax: ERROR"
    echo "Configuration invalid. Aborting."
    exit 1
fi
echo "  Modules loaded: $(sudo apache2ctl -M 2>/dev/null | grep -oE '[a-z_]+_module' | sed 's/_module//' | paste -sd, | sed 's/,/, /g')"
echo ""
echo "Starting Apache service..."
sudo systemctl start apache2
if sudo systemctl is-active apache2 >/dev/null 2>&1; then
    echo "  apache2.service: Started"
else
    echo "  apache2.service: FAILED"
    exit 1
fi
echo ""
echo "Health check..."
http_code=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/)
echo "  HTTP GET /: $http_code OK"
echo ""
echo "Apache restored successfully."
