/** Class representing a Stack. */

class Stack {
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
  * Adds new value at end of stack.
  * @param {*} value - value to add.
  */
  push (value) {
    this._storage.push(value)
  }

  /*
  * Remove value at end of stack and return it.
  * @return {*} Last and newest value in stack.
  */
  pop () {
    if (!this.length) return undefined
    this._storage.pop()
    return this.peek()
  }

  /*
  * Return value at end of stack without removing it.
  * @return {*} Last and newest value in stack.
  */
  peek () {
    if (!this.length) return undefined
    return this._storage[this.length - 1]
  }
}

// const myStack = new Stack()
// myStack.push('one')
// myStack.push('two')
// myStack.push('three')
// console.log(myStack)
// myStack.pop()
// console.log(myStack)
// myStack.pop()
// myStack.pop()
// myStack.pop()
// console.log(myStack)

class StackObject {
  constructor () {
    this._storage = {}
    this._length = 0
  }

  /*
  * Adds new value at end of stack.
  * @param {*} value - value to add.
  */
  push (value) {
    this._storage[this._length] = value
    this._length++
  }

  /*
  * Remove value at end of stack and return it.
  * @return {*} Last and newest value in stack.
  */
  pop () {
    if (!this._length) return undefined
    delete this._storage[this._length - 1]
    this._length--
    return this.peek()
  }

  /*
  * Return value at end of stack without removing it.
  * @return {*} Last and newest value in stack.
  */
  peek () {
    if (!this._length) return undefined
    return this._storage[this._length - 1]
  }
}

// const myStackO = new StackObject()
// myStackO.push('one')
// myStackO.push('two')
// myStackO.push('three')
// console.log(myStackO)
// myStackO.pop()
// console.log(myStackO)
// myStackO.pop()
// myStackO.pop()
// myStackO.pop()
// console.log(myStackO)
