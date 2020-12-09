'use strict';

const text = 'Yx`7cen7v7ergrvc~yp:|rn7OXE7t~g.re97R9p97~c7d.xb{s7cv|r7v7dce~yp75.r{{x7`xe{s57vys;7p~ary7c.r7|rn7~d75|rn5;7oxe7c.r7q~edc7{rccre75.57`~c.75|5;7c.ry7oxe75r57`~c.75r5;7c.ry75{57`~c.75n5;7vys7c.ry7oxe7yroc7t.ve75{57`~c.75|57vpv~y;7c.ry75x57`~c.75r57vys7dx7xy97Nxb7zvn7bdr7vy7~ysro7xq7tx~yt~srytr;7_vzz~yp7s~dcvytr;7\\vd~d|~7rovz~yvc~xy;7dcvc~dc~tv{7crdcd7xe7`.vcrare7zrc.xs7nxb7qrr{7`xb{s7d.x`7c.r7urdc7erdb{c9';
const englishLetterFrequency = [8.2, 1.5, 2.8, 4.3, 13, 2.2, 2, 6.1, 7, 0.15, 0.77, 4, 2.4, 6.7, 7.5, 1.9, 0.095, 6, 6.3, 9.1, 2.8, 0.98, 2.4, 0.15, 2, 0.074];

const main = () => {
  // key must be in range [1; 255]
  // let keyIndex = 23;

  // const stdin = process.openStdin();
  // stdin.setRawMode(true);
  // stdin.resume();
  // stdin.setEncoding('utf8');

  // stdin.on('data', (key) => {
  //   // ctrl-c ( end of text )
  //   if (key === '\u0003') process.exit();
  //   if (key === ' ') {
  //     console.log(`\nkey = ${keyIndex}\n`);
  //     console.log(xorDecrypt(text, keyIndex++));
  //   };
  // });

  const chiSquares = [];

  for (let key = 1; key < 256; key ++) {
    const decryptedText = xorDecrypt(text, key);
    const chiSquare = calcChiSquare(decryptedText);
    chiSquares.push(+chiSquare);
  }

  const minDeviation = Math.min(...chiSquares);
  const minDeviationKey = chiSquares.findIndex(chiSquare => chiSquare === minDeviation) + 1;

  console.log("key is ", minDeviationKey);
  console.log(xorDecrypt(text, minDeviationKey));
};

const xorDecrypt = (encryptedString, key = 1) => {
  const decryptedLetters = encryptedString.split('').map((letter) => String.fromCharCode(key ^ letter.charCodeAt()));
  return decryptedLetters.join('');
};

const calcChiSquare = (string) => {
  const aLetterChar = 97;
  const zLetterChar = 122;

  let chiSquare = 0;
  for (let letter = aLetterChar; letter <= zLetterChar; letter++) {
    const regEx = new RegExp(`[${String.fromCharCode(letter)}]`, 'g');
    const text = string.match(regEx);
    
    const letterCount = text ? text.length : 0;
    const basicLetterCount = englishLetterFrequency[letter - aLetterChar] / 100 * string.length;
    
    chiSquare += Math.pow(letterCount - basicLetterCount, 2) / basicLetterCount;
  }

  return chiSquare;
}

main();
