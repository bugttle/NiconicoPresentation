import os from 'os';

export default class NetworkInterface {

    static isLocalhost(ip) {
        return (ip === '127.0.0.1'
            || ip === '::1'
            || ip === 'localhost');
    }

    /**
     * Find IPv4/IPv6 addresses
     */
    static findFirstAddress() {
        const addresses = this.getAddresses();
        if (addresses.hasOwnProperty('IPv4')) {
            return addresses['IPv4'];
        } else if (addresses.hasOwnProperty('IPv6')) {
            return addresses['IPv6'];
        }
        return '';
    }

    static getAddresses() {
        const addresses = {};

        const ifaces = os.networkInterfaces();
        Object.keys(ifaces).forEach((ifname) => {
            ifaces[ifname].forEach((iface) => {
                if (iface.internal) {
                    return;  // skip over internal (i.e. 127.0.0.1)
                }

                switch (iface.family) {
                    case 'IPv4':
                    case 'IPv6':
                        if (!addresses.hasOwnProperty(iface.family)) {
                            // if this is first address
                            addresses[iface.family] = iface.address;
                        }
                        break;
                    default:
                        break;
                }
            });
        });

        return addresses;
    }
}