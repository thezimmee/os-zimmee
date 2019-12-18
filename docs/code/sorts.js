var text = `There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isn't anything embarrassing hidden in the middle of text. All the Lorem Ipsum generators on the Internet tend to repeat predefined chunks as necessary, making this the first true generator on the Internet. It uses a dictionary of over 200 Latin words, combined with a handful of model sentence structures, to generate Lorem Ipsum which looks reasonable. The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.`

function sort (string) {
  const sorted = []
  string = string.replace(/\.|,|-|'/g, '').split(/\s/)
  string.forEach((word, n) => {
    if (!sorted.length) {
      sorted.push(word)
    } else {
      sorted.some((sortedWord, i) => {
        if (i === sorted.length - 1 || word.toLowerCase() < sorted[i].toLowerCase()) {
          sorted.splice(i, 0, word)
          return true
        }
      })
    }
  })
  return sorted.join(' ')
}

function findMostCommonWords (string) {
  const wordsMap = {}
  string = string.replace(/\.|,|-|'/g, '').split(/\s/)
  string.forEach((word, n) => {
    if (!wordsMap[word]) wordsMap[word] = 0
    wordsMap[word]++
  })

  const sorted = []
  Object.keys(wordsMap).forEach((word, i) => {
    const w = [word, wordsMap[word]]
    if (i === 0) sorted.push(w)
    else {
      sorted.some((sortedWord, i) => {
        if (
          i === sorted.length - 1 ||
          w[1] > sortedWord[1] ||
          (w[1] === sortedWord[1] && w[0].toLowerCase() < sortedWord[0].toLowerCase())
        ) {
          sorted.splice(i, 0, w)
          return true
        }
      })
    }
  })

  return {
    map: wordsMap,
    sorted
  }
}

console.log(findMostCommonWords(text))
