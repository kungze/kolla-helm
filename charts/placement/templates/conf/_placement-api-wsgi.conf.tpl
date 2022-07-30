Listen 0.0.0.0:8778
ServerSignature Off
ServerTokens Prod
TraceEnable off

<VirtualHost *:8778>
    WSGIDaemonProcess placement-api processes=5 threads=1 user=placement group=placement display-name=%{GROUP} python-path=/var/lib/kolla/venv/lib/python3.8/site-packages
    WSGIProcessGroup placement-api
    WSGIScriptAlias / /var/lib/kolla/venv/bin/placement-api
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    <IfVersion >= 2.4>
      ErrorLogFormat "%{cu}t %M"
    </IfVersion>
    ErrorLog "/var/log/kolla/placement/placement-api.log"
    LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b %D \"%{Referer}i\" \"%{User-Agent}i\"" logformat
    CustomLog "/var/log/kolla/placement/placement-api-access.log" logformat
    <Directory /var/lib/kolla/venv/bin>
        <Files placement-api>
            Require all granted
        </Files>
    </Directory>
</VirtualHost>
