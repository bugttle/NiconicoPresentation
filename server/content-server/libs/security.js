import md5 from 'md5';

export default class Security {
    static generateRandomKey() {
        const now = Date.now();
        const random = Math.floor(Math.random() * now); // min:0, max:now
        return md5(`${now}:${random}`);
    }
}
