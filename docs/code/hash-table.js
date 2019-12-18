/** Class representing a Hash Table */

class HashTable {
  constructor (size) {
    this._storage = []
    this._tableSize = size
  }

  /*
  * Inserts a new key-value pair
  * @param {string} key - the key associated with the value
  * @param {*} value - the value to insert
  */
  insert (key, value) {
    const index = this._hash(key, this._tableSize)
    if (!this._storage[index]) this._storage[index] = []
    if (this._storage[index].some(v => v[0] === key)) return false
    this._storage[index].push([key, value])
  }

  /*
  * Deletes a key-value pair
  * @param {string} key - the key associated with the value
  * @return {*} value - the deleted value
  */
  remove (key) {
    const index = this._hash(key, this._tableSize)
    const itemIndex = this._storage[index].findIndex(v => v[0] === key)
    const item = this._storage[index][itemIndex]
    if (this._storage[index].length > 1) {
      this._storage[index].splice(itemIndex)
    } else {
      delete this._storage[index]
    }
    return item
  }

  /*
  * Returns the value associated with a key
  * @param {string} key - the key to search for
  * @return {*} - the value associated with the key
  */
  retrieve (key) {
    const index = this._hash(key, this._tableSize)
    return this._storage[index].find(v => v[0] === key)
  }

  /*
  * Hashes string value into an integer that can be mapped to an array index
  * @param {string} str - the string to be hashed
  * @param {number} n - the size of the storage array
  * @return {number} - an integer between 0 and n
  */
  _hash (str, n) {
    let sum = 0
    for (let i = 0; i < str.length; i++) { sum += str.charCodeAt(i) * 3 }

    return sum % n
  }
}

const myHT = new HashTable(25)
console.log(myHT)

myHT.insert('a', 1)
myHT.insert('b', 2)

console.log(myHT._storage)
console.log(myHT.retrieve('b'))

myHT.remove('a')
console.log(myHT._storage)
