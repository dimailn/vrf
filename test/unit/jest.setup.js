const realDescribe = describe;
describe = function(name, fn) { realDescribe(name, () => { fn(); }); };