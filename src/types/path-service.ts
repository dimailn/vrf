import set from '@/utils/set';

export default class PathService {
  root: object

  constructor() {
    this.root = {};
  }

  add(parentPath, name) {
    if (parentPath) {
      return set(this.root, parentPath, {
        [`${name}`]: {}
      });
    } else {
      return this.root[name] = {};
    }
  }

  getRootByPath(path = []) {
    return path.reduce((result, key) => {
      return result[key]
    }, this.root)
  }
}
