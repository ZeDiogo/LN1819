DIR = './corpora/'
RESOURCES = './recursos/'
PLOTS = './plots/'
# TRAIN = DIR + 'QuestoesConhecidas.txt'
# TEST = DIR + 'NovasQuestoes.txt'
TEST_SOL = 'TesteRespostas.txt'
DEBUG = True;

import sys
import os
import re
import pandas as pd
import nltk
import string
import math
from nltk.stem import WordNetLemmatizer
from nltk.stem.lancaster import LancasterStemmer
from sklearn import metrics
from classifier import Classifier
import numpy as np
import matplotlib.pyplot as plt
from collections import Counter

remove_punct = str.maketrans('','',string.punctuation)
CSF = 'SCVlinear_idf_unigrams'

def mergeDicts(dictionary, keys, value):
    for key in keys:
        dictionary[key] = value
    return dictionary

def builtVocabulary():
    vocabulary = {}
    for filename in os.listdir(RESOURCES):
        res = pd.read_csv(RESOURCES + filename, sep='\n', header=None)
        compLabel = re.search('list_(.+?).txt', filename)
        label = compLabel.group(1)
        res.columns = [label]
        vocab = tokenize_words(res[label].tolist())
        vocabulary = mergeDicts(vocabulary, vocab, label)
    
    return list(set(vocabulary))

def train(filename):
    corpora, labels = getCorporaLabels(filename)
    classifier = Classifier(corpora, labels)
    # vocab = builtVocabulary()
    #   idf, ngrams, stopWords, vocabulary
    classifier.useVectorizerParams(False, (1,1), 'english', None)
    classifier.useClassifier('KNeighborsClassifier')

    # print('Train Accuracy: ', classifier.getCrossValidationScore()*100, '%')
    return classifier

def getCorporaLabels(filename):
    res = pd.read_csv(filename, sep='\t', header=None)
    res.columns = ["Category","Sentences"]
    data_columns = res["Sentences"].tolist()
    labels = res["Category"].tolist()
    corpora = tokenize_words(data_columns)
    labels = list(map(str.strip, labels))
    return corpora, labels

def getCorpora(filename):
    res = pd.read_csv(filename, sep='\n', header=None)
    res.columns = ['Sentences']
    return tokenize_words(res['Sentences'].tolist())

def getLabels(filename):
    res = pd.read_csv(filename, sep='\n', header=None)
    res.columns = ['Category']
    labels = res['Category'].tolist()
    #remove trailing spaces
    return list(map(str.strip, labels))

def test(classifier, filename):
    corpora = getCorpora(filename)
    csf = classifier.getClassifier()
    vectorizer = classifier.getVectorizer()
    vec = vectorizer.transform(corpora)
    predictions = csf.predict(vec)
    printResults(predictions) #for final delivery

    #DEBUG
    if (DEBUG):
        labels = getLabels(TEST_SOL)
        score = metrics.accuracy_score(labels, predictions)
        save_file("resultados.txt", predictions) #for debugging
        print('Test Accuracy: ', score*100, '%') #to comment
        plotName = CSF
        plotResults(labels, predictions, PLOTS + plotName + '.png', score*100)

def printResults(predictions):
    for prediction in predictions:
        print(prediction)

def save_file(name,data):
    f = open(name,"w")
    for i in range(len(data)):
        if (i == len(data)):
            f.write(data[i])
        else:
            f.write(data[i]+"\n")
    f.close()

def tokenize_words(data):
    normalizer = LancasterStemmer()
    #normalizer = WordNetLemmatizer()
    sentences_tokens = []
    for i in range(len(data)):
        #remover sinais de pontuação
        data[i] = data[i].translate(remove_punct)

        sentence = nltk.word_tokenize(data[i])
        lemma_tokens = [] #guarda o lemma dos tokens da frase
        # print("Sentence: ", sentence)
        for j in range(len(sentence)):
            if (j == 0): #fa primeira palavra e convertida para minuscula
                #lemma_tokens.append(normalizer.lemmatize(normalizer.lemmatize(sentence[j].lower(),'v')))    
                lemma_tokens.append(normalizer.stem(normalizer.stem(sentence[j].lower())))
            else: 
                #lemma_tokens.append(normalizer.lemmatize(normalizer.lemmatize(sentence[j],'v')))
                lemma_tokens.append(normalizer.stem(normalizer.stem(sentence[j])))
        lemma_sentence = " ".join(lemma_tokens)
        sentences_tokens.append(lemma_sentence.strip())
        # print("Lemma sentence: ", lemma_sentence)
    return(sentences_tokens)

def plotResults(labels, predictions, filename, score):

    labelsDict = Counter(labels)
    predictionsDict = Counter(predictions)
    
    #merge dictionaries
    dictionary = {}
    for key in labelsDict:
        dictionary[key] = [labelsDict[key], 0]

    for key in predictionsDict:
        if key not in dictionary:
            dictionary[key] = [0, predictionsDict[key]]
        else:
            dictionary[key] = [dictionary[key][0], predictionsDict[key]]

    allLabels = list(dictionary)
    values = list(dictionary.values())
    labelsValues = [v[0] for v in values]
    predictionsValues = [v[1] for v in values]
    
    numberGroups = len(allLabels)
    fig, ax = plt.subplots()
    index = np.arange(numberGroups)
    barWidth = 0.3
    opacity = 0.8

    blue = ['#a6bddb', '#1c9099']
    green = ['#a1d99b', '#31a354']

    bar1 = plt.bar(index, labelsValues, barWidth, alpha=opacity, color=blue[0], label='Expected')     
    bar2 = plt.bar(index + barWidth, predictionsValues, barWidth, alpha=opacity, color=blue[1], label='Obtained')
    plt.xlabel('Sentences')
    plt.ylabel('Labels')
    plt.title(CSF + ' accuracy: ' + "{0:.2f}".format(round(score, 2)) + '%')
    plt.xticks(index + barWidth, allLabels)
    plt.legend()    
    plt.tight_layout()
    # plt.show()
    fig.savefig(filename)

def parseInput():
    TRAIN = sys.argv[1]
    TEST = sys.argv[2]
    return TRAIN, TEST

def main():
    TRAIN, TEST = parseInput()
    classifier = train(TRAIN)
    test(classifier, TEST)

main()