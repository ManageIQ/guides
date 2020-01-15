### Remote Consoles

ManageIQ includes 3rd party HTML5/Javascript implementation of VNC and SPICE remote access protocols. These are used to connect to VMWare and RHEV virtual machines running on hypervisors.

The VNC (or SPICE) data is wrapped into web socket protocol and SSL (wss://). The proxy is implemented as a separate ManageIQ worker and on an appliance it runs behind Apache on port 443 together with the rest of the UI (worker, static assets, SUI) as well as the API.

Remote consoles are also supported for OpenStack but OpenStack includes it's own HTML5/Javascript clients and ManageIQ just opens URL provided by OpenStack API. Therefore ManageIQ does not do any tunelling or proxying for the OpenStack consoles.


In some deployment scenarios the appliance running the UI role does not have the visibility to the hypervisors that expose the VNC/SPICE endpoints. For this case ManageIQ includes an option for a 2nd level proxy.

In the 2nd level proxy scenario the websocket worker connects to a backend appliance that runs a `socat` process that forwards the TCP connection to the hypervisor.


WebMKS consoles are supported, but we can not distribute the code needed for that. Therefore, for webmks support, it is first necessary to download the relevant SDK from the official site, and to manually put `wmks.min.js` and `wmks-all.css` into a (new) `/var/www/miq/vmdb/public/webmks/` directory on the appliance.
