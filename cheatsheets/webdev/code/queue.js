/** Class representing a Queue. */

class Queue {
  constructor () {
    this._storage = []
  }

  /*
  * Get length of storage.
  * @return {Number} length of this._storage.
  */
  get length () {
    return this._storage.length
  }

  /*
  * Enqueue/add a new value at end of queue.
  * @param {*} value - value to enqueue.
  */
  enqueue (value) {
    this._storage.push(value)
  }

  /*
  * Dequeue/remove value from beginning of queue and return it.
  * @return {*} first and oldest value in queue.
  */
  dequeue () {
    if (!this._storage.length) return undefined
    this._storage.shift()
    return this.peek()
  }

  /*
  * Return value at beginning of queue without removing it from queue.
  * @return {*} first and oldest value in queue.
  */
  peek () {
    if (!this._storage.length) return undefined
    return this._storage[this._storage.length - 1]
  }
}

const myQ = new Queue()
myQ.enqueue('one')
myQ.enqueue('two')
myQ.enqueue('three')
console.log(myQ)
myQ.dequeue()
console.log(myQ)
myQ.dequeue()
myQ.dequeue()
console.log(myQ.dequeue())
console.log(myQ)

class QueueObject {
  constructor () {
    this._storage = {}
    this._first = 0
    this._last = 0
  }

  /*
  * Enqueue/add a new value at end of queue.
  * @param {*} value - value to enqueue.
  */
  enqueue (value) {
    this._storage[this._last++] = value
  }

  /*
  * Dequeue/remove value from beginning of queue and return it.
  * @return {*} first and oldest value in queue.
  */
  dequeue () {
    // If it's empty, return undefined.
    if (this._last === 0) return undefined
    // Delete first and update _first.
    delete this._storage[this._first]
    this._first++
    return this.peek()
  }

  /*
  * Return value at beginning of queue without removing it from queue.
  * @return {*} first and oldest value in queue.
  */
  peek () {
    if (this._last === 0) return undefined
    return this._storage[this._last]
  }
}

// const myQO = new QueueObject()
// myQO.enqueue('one')
// myQO.enqueue('two')
// myQO.enqueue('three')
// console.log(myQO)
// myQO.dequeue()
// console.log(myQO)
// myQO.dequeue()
// myQO.dequeue()
// myQO.dequeue()
// console.log(myQO)
// myQO.enqueue('four')
// myQO.enqueue('five')
// myQO.enqueue('six')
// console.log(myQO)