import { get, def } from 'bdd-lazy-var/global'
import '@testing-library/jest-dom'

const realDescribe = describe;
describe = function(name, fn) { realDescribe(name, () => { fn(); }); };