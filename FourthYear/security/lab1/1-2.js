'use strict'

// Now try a repeating-key XOR cipher. E.g. it should take a string "hello world" and,
// given the key is "key", xor the first letter "h" with "k", then xor "e" with "e",
// then "l" with "y", and then xor next char "l" with "k" again, then "o" with "e" and so on.
// You may use an index of coincidence, Hamming distance, Kasiski examination, statistical tests or
// whatever method you feel would show the best result.

const main = () => {
  const hexString = "1c41023f564b2a130824570e6b47046b521f3f5208201318245e0e6b40022643072e13183e51183f5a1f3e4702245d4b285a1b23561965133f2413192e571e28564b3f5b0e6b50042643072e4b023f4a4b24554b3f5b0238130425564b3c564b3c5a0727131e38564b245d0732131e3b430e39500a38564b27561f3f5619381f4b385c4b3f5b0e6b580e32401b2a500e6b5a186b5c05274a4b79054a6b67046b540e3f131f235a186b5c052e13192254033f130a3e470426521f22500a275f126b4a043e131c225f076b431924510a295f126b5d0e2e574b3f5c4b3e400e6b400426564b385c193f13042d130c2e5d0e3f5a086b52072c5c192247032613433c5b02285b4b3c5c1920560f6b47032e13092e401f6b5f0a38474b32560a391a476b40022646072a470e2f130a255d0e2a5f0225544b24414b2c410a2f5a0e25474b2f56182856053f1d4b185619225c1e385f1267131c395a1f2e13023f13192254033f13052444476b4a043e131c225f076b5d0e2e574b22474b3f5c4b2f56082243032e414b3f5b0e6b5d0e33474b245d0e6b52186b440e275f456b710e2a414b225d4b265a052f1f4b3f5b0e395689cbaa186b5d046b401b2a500e381d4b23471f3b4051641c0f2450186554042454072e1d08245e442f5c083e5e0e2547442f1c5a0a64123c503e027e040c413428592406521a21420e184a2a32492072000228622e7f64467d512f0e7f0d1a";
  const englishLetterFrequency = [8.2, 1.5, 2.8, 4.3, 13, 2.2, 2, 6.1, 7, 0.15, 0.77, 4, 2.4, 6.7, 7.5, 1.9, 0.095, 6, 6.3, 9.1, 2.8, 0.98, 2.4, 0.15, 2, 0.074];
  
  const inputString = Buffer.from(hexString, 'hex').toString('latin1');

  // if key is longer than half of the encoded string, we won't recognize its length
  const indexesOfCoincidence = calcIndexOfCoincidence(inputString, inputString.length / 2);
  const maxKeyLength = Math.floor(hexString.length / 2);
  const keyLength = calcKeyLength(indexesOfCoincidence, maxKeyLength);
  console.log('key length =', keyLength);

  const substrings = splitIntoSubstrings(inputString, keyLength);
  const minChiSquares = [];

  substrings.forEach((substring, index) => {
    for (let key = 33; key <= 127; key++) {
      const decryptedString = xorDecrypt(substring, key);
      const chiSquare = calcChiSquare(decryptedString, englishLetterFrequency);

      if (!minChiSquares[index]) {
        minChiSquares[index] = [{ key, value: chiSquare }];
      } else {
        minChiSquares[index].push({ key, value: chiSquare });
      }
    }
  });

  const keyArray = minChiSquares.map((minsArray) => {
    let minKey;
    let minValue = minsArray[0].value;

    for (let obj of minsArray) {
      if (obj.value < minValue) {
        minValue = obj.value;
        minKey = obj.key;
      }
    }

    return String.fromCharCode(minKey);
  });

  const key = keyArray.join('');
  console.log('key: ', key);
  
  const decryptedMessage = inputString.split('').map((letter, index) => {
    const i = index % keyLength;
    return xorDecrypt(letter, key[i].charCodeAt());
  });

  console.log(decryptedMessage.join(''));
}

const calcIndexOfCoincidence = (string, iterations) => {
  const coincidence = [0];

  for (let iter = 1; iter <= iterations; iter++) {
    const stringToCompare =
      string.substring(string.length - iter) + string.substring(0, string.length - iter);

    let numberOfEqualChars = 0;
    for (let i = 0; i < string.length - 1; i++) {
      if (string[i] === stringToCompare[i]) numberOfEqualChars += 1;
    }
    
    const indexOfCoincidence = numberOfEqualChars / string.length;
    coincidence.push(indexOfCoincidence);
  }

  return coincidence;
}

const calcKeyLength = (coincidences, maxKeyLength) => {
  const numberOfMaxsByKeyLength = new Array(maxKeyLength).fill(0);

  for (let keyLength = 2; keyLength < maxKeyLength; keyLength++) {
    let iter = 0;
    while (iter * keyLength < coincidences.length) {
      const isVertexMax = isMax(coincidences, iter * keyLength);

      if (isVertexMax) {
        numberOfMaxsByKeyLength[keyLength]++;
      }

      iter++;
    }
  }

  const mostPossibleKeyLength = Math.max(...numberOfMaxsByKeyLength);

  return numberOfMaxsByKeyLength.findIndex(index => index === mostPossibleKeyLength);
};

const isMax = (array, index) => {
  return array[index] >= array[index - 1] && array[index] >= array[index + 1];
};

const calcChiSquare = (string, basicFrequency) => {
  const aLetterChar = 97;
  const zLetterChar = 122;

  let chiSquare = 0;
  for (let letter = aLetterChar; letter <= zLetterChar; letter++) {
    const regEx = new RegExp(`[${String.fromCharCode(letter)}]`, 'g');
    const text = string.match(regEx);
    
    const letterCount = text ? text.length : 0;
    const basicLetterCount = basicFrequency[letter - aLetterChar] / 100 * string.length;
    
    chiSquare += Math.pow(letterCount - basicLetterCount, 2) / basicLetterCount;
  }

  return chiSquare;
}

const splitIntoSubstrings = (string, numberOfSubstrings) => {
  const substrings = [];

  string.split('').forEach((letter, index) => {
    const substringIndex = index % numberOfSubstrings;
    if (!substrings[substringIndex]) {
      substrings[substringIndex] = letter + '';
    } else {
      substrings[substringIndex] += letter;
    }
  })
  
  return substrings;
}

const xorDecrypt = (encryptedString, key = 1) => {
  const decryptedLetters = encryptedString.split('').map((letter) => String.fromCharCode(key ^ letter.charCodeAt()));
  return decryptedLetters.join('');
};

main()
