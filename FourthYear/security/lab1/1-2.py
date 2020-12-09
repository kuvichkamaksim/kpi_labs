#   Now try a repeating-key XOR cipher. E.g. it should take a string "hello world" and,
#   given the key is "key", xor the first letter "h" with "k", then xor "e" with "e",
#   then "l" with "y", and then xor next char "l" with "k" again, then "o" with "e" and so on.
#   You may use an index of coincidence, Hamming distance, Kasiski examination, statistical tests or
#   whatever method you feel would show the best result.

import plotly.express as px
import pandas as pd
import re
from collections import Counter
from scipy.stats import chisquare

def main():
    input_string = ''' A ?VK*  $W kG kR ?R    $^ k@ &C .  >Q ?Z >G $]K(Z #V e ?$  .W (VK?[ kP &C .K ?JK$UK?[ 8  %VK<VK<Z '  8VK$] 2  ;C 9P
        8VK'V ?V 8 K8\K?[ kX 2@ *P kZ k\ 'JKy Jkg kT ?  #Z k\ .  "T ? 
        >G &R "P
        '_ kJ >  "_ kC $Q
        )_ k] .WK?\K>@ k@ &VK8\ ?  -  .] ?Z kR ,\ "G & C<[ ([K<\  V kG .  .@ k_
        8GK2V
        9 Gk@ &F *G / 
        %] *_ %TK$AK,A
        /Z %GK/V (V ? K V "\ 8_ g  9Z .  ?  "T ?  $DGkJ >  "_ k] .WK"GK?\K/V "C .AK?[ k] 3GK$] kR kD '_Ekq *AK"]K&Z / K?[ 9V‰Ëª k] k@ *P 8 K#G ;@Qd  $P eT $T .  $^D/\ >^ %GD/ Z
        d <P> ~  A4(Y$ R !B  J*2I r (b.dF}Q/ 
        '''

    # x_values = []
    # y_values = []

    # number_of_iterations = 32
    # calc_index_of_coincidence(input_string, number_of_iterations,  x_values, y_values)

    # df = pd.DataFrame({'index': x_values, 'index_of_coincidence': y_values})
    # fig = px.bar(df, x = "index", y = 'index_of_coincidence')
    # fig.show()

    english_letter_frequency = [8.2, 1.5, 2.8, 4.3, 13, 2.2, 2, 6.1, 7, 0.15, 0.77, 4, 2.4, 6.7, 7.5, 1.9, 0.095, 6, 6.3, 9.1, 2.8, 0.98, 2.4, 0.15, 2, 0.074]

    substrings = split_into_substrings(input_string, 3)

    for substring in substrings:
        for key in range(33, 127):
            decrypted_string = xorDecrypt(substring, key)
            chi_square = calc_chi_square(decrypted_string, english_letter_frequency)
            print(key, '\t', int(chi_square))
        print('\n\n\n')

def calc_index_of_coincidence(string, iterations, shifts, coincidence):
    for iter in range(1, iterations):
        stringToCompare = string[-iter:] + string[:-iter]
        shifts.append(iter)

        numberOfEqualChars = 0
        for i in range(len(string) - 1):
            if (string[i] == stringToCompare[i]):
                numberOfEqualChars += 1
        
        index_of_coincidence = numberOfEqualChars / len(string)
        coincidence.append(index_of_coincidence)
        # print('percent of coincidence =', index_of_coincidence, '%')

def calc_chi_square(string, basic_frequency):
    a_letter_char = 97
    z_letter_char = 122

    chi_square = 0
    for letter in range(a_letter_char, z_letter_char + 1):
        re_exp = "[^{}{}]+".format(chr(letter), chr(letter - 32))
        text = re.sub(re_exp, "", string)

        letter_count = len(text)
        basic_letter_count = basic_frequency[letter - a_letter_char] / 100 * len(string)

        chi_square += pow(letter_count - basic_letter_count, 2) / basic_letter_count

    return chi_square

def split_into_substrings(string, number_of_substrings):
    substrings = [''] * number_of_substrings

    for i in range(len(string)):
        substrings[i % number_of_substrings] += string[i]
    return substrings

def xorDecrypt(string, key):
    decrypted_string = ''
    for letter in range(len(string)):
        decrypted_letter = ord(string[letter]) ^ key
        decrypted_string += chr(decrypted_letter)

    return decrypted_string

def calculateChiSquredToEnglish(inputText):
    Alphabet = ['a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z']
    
    text = re.sub("[^a-zA-Z]+", "", inputText)
    letters_frequency_list = []
    counts = Counter(text)
    for letter in Alphabet:
        letters_frequency_list.append(counts[letter]/len(text)*100 if letter in counts else 0)
        result = chisquare(letters_frequency_list,
              f_exp=[8.2, 1.5, 2.8, 4.3, 13, 2.2, 2, 6.1, 7, 0.15, 0.77, 4, 2.4, 6.7, 7.5, 1.9, 0.095, 6, 6.3, 9.1, 2.8,
                     0.98, 2.4, 0.15, 2, 0.074])
    return result.pvalue

main()
