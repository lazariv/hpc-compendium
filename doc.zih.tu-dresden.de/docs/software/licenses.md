# Use of External Licenses

It is possible (please [contact the support team](../support/support.md) first) for users to install
their own software and use their own license servers, e.g.  FlexLM. The outbound IP addresses from
ZIH systems are:

- compute nodes: NAT via 141.76.3.193
- login nodes: 141.30.73.102-141.30.73.105

The IT department of the external institute has to open the firewall for license communications
(might be multiple ports) from ZIH systems and enable handing-out license to these IPs and login.

The user has to configure the software to use the correct license server. This can typically be done
by environment variable or file.

!!! attention

    If you are using software we have installed, but bring your own license key (e.g.
    commercial ANSYS), make sure that to substitute the environment variables we are using as default!
    (To verify this, run `printenv|grep licserv` and make sure that you dont' see entries refering to
    our ZIH license server.)
