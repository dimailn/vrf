import { get, def } from 'bdd-lazy-var/global'

const realDescribe = describe;
describe = function(name, fn) { realDescribe(name, () => { fn(); }); };