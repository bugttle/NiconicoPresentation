import * as os from 'os';

export default class NetworkInterface {
  public static getAddresses(): string[] {
    const addresses: string[] = [];

    const ifaces = os.networkInterfaces();
    Object.keys(ifaces).forEach((ifname) => {
      let alias = 0;
      ifaces[ifname].forEach((iface: os.NetworkInterfaceInfo) => {
        if (iface.internal) {
          return;  // skip over internal (i.e. 127.0.0.1)
        }

        if (1 <= alias) {
          // this single interface has multiple ipv4 addresses
          addresses.push(`${ifname}:${alias} ${iface.address}`);
        } else {
          // this interface has only one ipv4 address
          addresses.push(`${ifname} ${iface.address}`);
        }
        ++alias;
      });
    });

    return addresses;
  }
}