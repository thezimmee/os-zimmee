function pathToValue (json, value, root) {
  let result = root || []

  for (var key in json) {
    // If json[key] is an object, recursively call pathToValue on this "branch"
    // of the object.
    if (typeof json[key] === 'object') {
      const nested = pathToValue(json[key], value, result)
      // If search through this branch returns a value, add it to result and
      // return result.
      if (nested !== undefined) {
        result = result.concat(nested)
        return result
      }
    // If json[key] is a primitive and equals value, add the path and return it.
    } else if (json[key] === value) {
      result.push(key)
      return result
    }
  }

  // If we arrive here, we've iterated through json and not found value.
  return undefined
}

let json = JSON.parse('["a", 0, "bool"]')
console.log(pathToValue(json, 'a')) // [0]
console.log(pathToValue(json, 'z')) // undefined

json = JSON.parse('{"a": [{"int": 1, "str": "foo", "bool": true}]}')
console.log(pathToValue(json, 1)) // ['a', 0, 'int'] console.log('---')
console.log(pathToValue(json, true)) // ['a', 0, 'bool']
// console.log('---')
console.log(pathToValue(json, 'bar')) // undefined
