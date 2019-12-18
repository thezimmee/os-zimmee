(function () {
  const merchants = [
    'Chipotle',
    'Habit Burger',
    'Subway',
    'Jack In The Box'
  ]

  const cardholders = {
    Takashi: {
      balance: 220,
      approvedMerchants: ['Chipotle', 'Subway', 'Habit Burger']
    },
    Allura: {
      balance: 110,
      approvedMerchants: ['Chipotle']
    },
    Keith: {
      balance: 200,
      approvedMerchants: ['Subway', 'Jack In The Box']
    },
    Katie: {
      balance: 460,
      approvedMerchants: ['Chipotle', 'Subway', 'Habit Burger', 'Jack In The Box']
    }
  }

  const cards = [
    '4111111111111111', // valid
    '5500000000000004', // valid
    '340000000000009', // valid
    '4111111111111114', // invalid
    '5500000000000005', // invalid
    '340000000000003' // invalid
  ]

  function randomFromArray (array) {
    return array[Math.floor(Math.random() * array.length)]
  };

  function createTransaction () {
    const transactionInfo = {
      amount: (Math.random() * 50).toFixed(2),
      cardholder: randomFromArray(Object.keys(cardholders)),
      merchant: randomFromArray(merchants),
      card: randomFromArray(cards)
    }

    var transactionEvent = new CustomEvent(
      'transaction',
      { detail: transactionInfo }
    )

    window.dispatchEvent(transactionEvent)
  };

  setInterval(createTransaction, 1000)

  // Enter your JS code below

  // Notes:
  //
  // - I could have used <table>s to mark this up. For time and simplicity, I chose
  //  divs with flexbox.
  // - I could have used Web Components (https://developer.mozilla.org/en-US/docs/Web/Web_Components),
  //  along with ES2015 classes, for cleaner code and to more efficiently render to
  //  the DOM, but due to time constraints I went with a more functional approach.
  // - I worried less about design, per notes in test instructions, and also
  //  since I didn't have a mock up or prototype of any sort.
  // - With less time constraint I would give greater attention to mobile
  //  responsiveness, though I added a few mobile styles to at least show some
  //  responsiveness.
  // - Sidenote: I edited in my local IDE to utilize autocomplete and copied to
  //  solution here.

  // Set up app.
  const app = {
    main: document.querySelector('#app'),
    dashboards: {}
  }
  init()

  /**
  * Initialize the DOM and create transaction listener.
  */
  function init () {
    window.addEventListener('transaction', processTransaction)
    Object.keys(cardholders).forEach(name => {
      const cardholderDashboard = document.createElement('div')
      cardholderDashboard.innerHTML = `<div class="dashboard__header"><h2 class="dashboard__name">${name}</h2><div class="dashboard__balance">$${cardholders[name].balance}</div></div><div class="dashboard__transactions"><div class="dashboard__empty-message">No transactions yet...</div></div>`
      cardholderDashboard.id = `dashboard__${name}`
      cardholderDashboard.classList.add('dashboard')
      app.dashboards[name] = cardholderDashboard
      app.main.appendChild(cardholderDashboard)
    })
  }

  /*
  * Process each transaction and approve or reject.
  * @param {Event} event - Custom transaction event with transaction details.
  */
  function processTransaction (event) {
    const transaction = event.detail
    const cardholder = cardholders[transaction.cardholder]
    transaction.isValid = false

    const date = new Date()
    transaction.date = `${date.getMonth() + 1}/${date.getDate()}/${date.getFullYear()}`

    transaction.isValid = hasSufficientFunds(cardholder, transaction.amount) && merchantIsApproved(cardholder, transaction.merchant) && cardIsValid(transaction.card)

    if (transaction.isValid) {
      cardholder.balance = (cardholder.balance - transaction.amount).toFixed(2)
    }

    updateDom(transaction, cardholder)

    return transaction.isValid
  }

  /*
  * Update the DOM on each transaction.
  * @param {Object} transaction - transactionInfo from created transaction.
  */
  function updateDom (transaction) {
    const dashboard = app.dashboards[transaction.cardholder]

    // Remove empty message.
    const emptyMessageEl = dashboard.querySelector('.dashboard__empty-message')
    if (emptyMessageEl) {
      emptyMessageEl.parentNode.removeChild(emptyMessageEl)
    }

    // Add transaction to DOM.
    const html = document.createElement('div')
    html.classList.add('transaction')
    if (!transaction.isValid) html.classList.add('transaction--denied')
    html.innerHTML = `<div class="transaction__top"><div class="transaction__date">${transaction.date}</div><div class="transaction__merchant">${transaction.merchant}</div><div class="transaction__amount">$${transaction.amount}</div></div><div class="transaction__bottom"><div class="transaction__status">${transaction.isValid ? 'Approved' : 'Denied'}</div><div class="transaction__card">card #: ${transaction.card}</div></div>`
    dashboard.querySelector('.dashboard__transactions').append(html)

    // Update balance.
    dashboard.querySelector('.dashboard__balance').innerHTML = `$${cardholders[transaction.cardholder].balance}`
  }

  /*
  * Test whether a card is valid.
  * @param {String} cardNumber - credit card number, as a String.
  */
  function cardIsValid (cardNumber) {
    let sumTotal = 0

    cardNumber.split('').reverse().forEach((n, i) => {
      // Process every second digit.
      if ((i + 1) % 2 === 0) {
        n = n * 2
        if (n > 9) {
          let sum = 0
          String(n).split('').forEach(num => {
            sum += Number(num)
          })
          n = sum
        }
      }

      // Add to total sum.
      sumTotal += Number(n)
    })

    // Return true if total sum is divisible by 10.
    return sumTotal % 10 === 0
  }

  /*
  * Test whether merchant is approved.
  * @param {Object} cardholder - Cardholder object.
  * @param {String} merchant - Name of merchant.
  */
  function merchantIsApproved (cardholder, merchant) {
    return merchants.includes(merchant) && cardholder.approvedMerchants.includes(merchant)
  }

  /*
  * Check if cardholder has sufficient funds for a transaction.
  * @param {Object} cardholder - Cardholder object.
  * @param {String} amount - transaction amount, as a string.
  */
  function hasSufficientFunds (cardholder, amount) {
    return cardholder.balance >= Number(amount)
  }
})()
