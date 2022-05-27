Listen 0.0.0.0:8776
ServerSignature Off
ServerTokens Prod
TraceEnable off

<VirtualHost *:8776>
    WSGIDaemonProcess cinder-api processes=5 threads=1 user=cinder group=cinder display-name=%{GROUP} python-path=/var/lib/kolla/venv/lib/python3.8/site-packages
    WSGIProcessGroup cinder-api
    WSGIScriptAlias / /var/www/cgi-bin/cinder/cinder-wsgi
    WSGIApplicationGroup %{GLOBAL}
    WSGIPassAuthorization On
    <IfVersion >= 2.4>
        ErrorLogFormat "%{cu}t %M"
    </IfVersion>
    ErrorLog /var/log/kolla/cinder/cinder-api.log
    LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b %D \"%{Referer}i\" \"%{User-Agent}i\"" logformat
    CustomLog /var/log/kolla/cinder/cinder-api-access.log logformat
</VirtualHost>
