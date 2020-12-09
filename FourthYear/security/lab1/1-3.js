// Write a code to attack some simple substitution cipher.
// To reduce the complexity of this one we will use only uppercase letters, so the keyspace is only 26!
// To get this one right automatically you will probably need to use some sort of genetic algorithm
// (which worked the best last year), simulated annealing or gradient descent.
// Seriously, write it right now, you will need it to decipher the next one as well.
// Bear in mind, there's no spaces. https://docs.google.com/document/d/1AWywcUIMoGr_cjOMaqjqeSyAyzK93icQE4W-6bDELfQ

const fs = require('fs');

const encryptedInput = 'EFFPQLEKVTVPCPYFLMVHQLUEWCNVWFYGHYTCETHQEKLPVMSAKSPVPAPVYWMVHQLUSPQLYWLASLFVWPQLMVHQLUPLRPSQLULQESPBLWPCSVRVWFLHLWFLWPUEWFYOTCMQYSLWOYWYETHQEKLPVMSAKSPVPAPVYWHEPPLUWSGYULEMQTLPPLUGUYOLWDTVSQETHQEKLPVPVSMTLEUPQEPCYAMEWWYTYWDLUULTCYWPQLSEOLSVOHTLUYAPVWLYGDALSSVWDPQLNLCKCLRQEASPVILSLEUMQBQVMQCYAHUYKEKTCASLFPYFLMVHQLUPQLHULIVYASHEUEDUEHQBVTTPQLVWFLRYGMYVWMVFLWMLSPVTTBYUNESESADDLSPVYWCYAMEWPUCPYFVIVFLPQLOLSSEDLVWHEUPSKCPQLWAOKLUYGMQEUEMPLUSVWENLCEWFEHHTCGULXALWMCEWETCSVSPYLEMQYGPQLOMEWCYAGVWFEBECPYASLQVDQLUYUFLUGULXALWMCSPEPVSPVMSBVPQPQVSPCHLYGMVHQLUPQLWLRPOEDVMETBYUFBVTTPENLPYPQLWLRPTEKLWZYCKVPTCSTESQPQULLGYAUMEHVPETFWMEHVPETBZMEHVPETB';

const A_CHAR_CODE = 65;
const Z_CHAR_CODE = 90;

const POPULATION_SIZE = 1000;
const MUTATION_POSSIBILITY = 0.2;
const GENERATIONS_COUNT = 750;

const getEnglishTrigrams = () => {
  const file = fs.readFileSync('english_trigrams.csv', 'utf-8');
  const data = file.toString().split('\n').slice(1);

  const trigrams = {};

  data.forEach((dataRow) => {
    const [trigram, frequency] = dataRow.split(',');
    trigrams[trigram] = frequency;
  })

  return trigrams;
};

const getRandomKeyAlphabet = () => {
  const alphabetNumbers = [];  
  for (let i = A_CHAR_CODE; i <= Z_CHAR_CODE; i++) {
    alphabetNumbers.push(i);
  }

  for (let i = alphabetNumbers.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [alphabetNumbers[i], alphabetNumbers[j]] = [alphabetNumbers[j], alphabetNumbers[i]];
  }
  return alphabetNumbers.map((letter) => String.fromCharCode(letter)).join('');
};

const generatePopulation = () => {
  const population = [];

  for (let i = 0; i < POPULATION_SIZE; i++) {
    population.push(getRandomKeyAlphabet());
  }

  return population;
};

const decrypt = (string, key) =>
  string.split('')
    .map((letter) => String.fromCharCode(key.indexOf(letter) + A_CHAR_CODE))
    .join('');

const getTrigrams = (text) => {
  const trigrams = {};
  let overallTrigramsOccurrences = 0;

  for (let i = 0; i < text.length - 2; ++i) {
    const trigram = text.slice(i, i + 3);
    if (!trigrams[trigram]) {
      const occurrencesCount = text.match(new RegExp(trigram, 'ig')).length;
      trigrams[trigram] = occurrencesCount;
      overallTrigramsOccurrences += occurrencesCount;
    }
  }

  for (const trigram in trigrams) {
    trigrams[trigram] = trigrams[trigram] / overallTrigramsOccurrences;
  }

  return trigrams;
};

const getScore = (key) => {
  const decryptedInput = decrypt(encryptedInput, key);
  const trigrams = getTrigrams(decryptedInput);
  const englishTrigrams = getEnglishTrigrams();

  const score = Object.entries(trigrams).reduce(
    (sum, [trigram, frequency]) => sum + frequency * Math.log2(englishTrigrams[trigram] || 0),
    0
  );

  return { key, score };
};

const getRandom30 = (array) => {
  const result = [];
  let i = 0;

  while (i < POPULATION_SIZE * 0.3) {
    const randomIndex = Math.floor(Math.random() * array.length);
    if (array[randomIndex]) {
      result.push(array[randomIndex]);
      array[randomIndex] = null;
      i++;
    }
  }

  return result;
};

const replaceRepeatedLetters = (string) => {
  const stringArray = string.split('').map((letter, i) => {
    if (string.indexOf(letter, i + 1) > -1) {
      return '_';
    };
    return letter;
  });

  const alphabet = [];  
  for (let i = A_CHAR_CODE; i <= Z_CHAR_CODE; i++) {
    alphabet.push(String.fromCharCode(i));
  }

  alphabet.forEach((letter) => {
    if (!stringArray.includes(letter)) {
      const underscoreIndex = stringArray.findIndex((elem) => elem === '_');
      stringArray[underscoreIndex] = letter;
    }
  });

  return stringArray.join('');
};

const calculateCrossover = (parent1, parent2) => {
  const crossoverPoint = Math.floor(Math.random() * parent1.length);

  const parent1_first = parent1.substring(0, crossoverPoint);
  const parent1_second = parent1.substring(crossoverPoint);
  const parent2_first = parent2.substring(0, crossoverPoint);
  const parent2_second = parent2.substring(crossoverPoint);

  const child1 = parent1_first + parent2_second;
  const child2 = parent2_first + parent1_second;

  return [replaceRepeatedLetters(child1), replaceRepeatedLetters(child2)];
};

const calculateMutation = (parent1, parent2) => {
  const checkArray = [];
  for (let i = 0; i < Z_CHAR_CODE - A_CHAR_CODE + 1; i++) {
    checkArray.push(Math.random() < 0.5);
  }
  
  const child = checkArray.map((bool, i) => (bool ? parent1[i] : '_'));

  parent2.split('').forEach((letter) => {
    if (!child.find((elem) => elem === letter)) {
      const underscoreIndex = child.findIndex((elem) => elem === '_');
      child[underscoreIndex] = letter;
    }
  })

  return child.join('');
};

const getChildren = (parents) => {
  const children = [];

  // shuffle parents array
  const randomParents = parents.slice();
  for (let i = randomParents.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [randomParents[i], randomParents[j]] = [randomParents[j], randomParents[i]];
  }

  for (let i = 0; i < randomParents.length / 2; i++) {
    const j = randomParents.length / 2 + i;
    let newChildren = calculateCrossover(randomParents[i], randomParents[j]);

    if (randomParents.length - i * 2 <= randomParents.length * MUTATION_POSSIBILITY) {
      const newChild1 = calculateMutation(randomParents[i], randomParents[j]);
      const newChild2 = calculateMutation(randomParents[i], randomParents[j]);
      newChildren = [newChild1, newChild2];
    }
    newChildren.forEach((child) => children.push(child));
  }

  return children;
};

const main = () => {
  let population = generatePopulation();

  for (let generation = 0; generation < GENERATIONS_COUNT; generation++) {
    const chromosomeScores = population
      .map((chromosome) => getScore(chromosome))
      .sort((a, b) => (b.score - a.score));
    
    if (generation % 5 === 0) {
      console.log('generation', generation);
      console.log('key', chromosomeScores[0].key);
      console.log('score', chromosomeScores[0].score);
      console.log('text', decrypt(encryptedInput, chromosomeScores[0].key));
      console.log('\n');
    }

    const best20 = chromosomeScores.slice(0, POPULATION_SIZE * 0.2);
    const random30 = getRandom30(chromosomeScores.slice(best20.length));
    const parents = [...best20, ...random30].map((elem) => elem.key);

    const children = getChildren(parents);

    const parentsInNextGeneration = [...best20, ...random30].map((elem) => elem.key);
    population = [...parentsInNextGeneration, ...children];
  }
};

main();
