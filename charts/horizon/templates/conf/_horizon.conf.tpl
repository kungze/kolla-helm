Listen 0.0.0.0:8181

ServerSignature Off
ServerTokens Prod
TraceEnable off

<VirtualHost *:8181>
    LogLevel warn
    ErrorLog /var/log/kolla/horizon/horizon.log
    LogFormat "%{X-Forwarded-For}i %l %u %t \"%r\" %>s %b %D \"%{Referer}i\" \"%{User-Agent}i\"" logformat
    CustomLog /var/log/kolla/horizon/horizon-access.log logformat

    WSGIScriptReloading On
    WSGIDaemonProcess horizon-http processes=5 threads=1 user=horizon group=horizon display-name=%{GROUP} python-path=/usr/share/openstack-dashboard
    WSGIProcessGroup horizon-http
    WSGIScriptAlias /horizon /usr/share/openstack-dashboard/openstack_dashboard/wsgi.py
    WSGIPassAuthorization On
    WSGIApplicationGroup %{GLOBAL}
    Alias /horizon/static /var/lib/openstack-dashboard/static

    
    <Location "/">
        Require all granted
    </Location>

    Alias /static /var/lib/openstack-dashboard/static
    <Location "/static">
        SetHandler None
    </Location>

</VirtualHost>
