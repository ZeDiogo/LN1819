from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.svm import SVC
from sklearn import metrics
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import Perceptron

class Classifier:

	def __init__(self, corpora, labels):
		self.corpora = corpora
		self.labels = labels
		#default vectorizer
		self.crossValidationScore = None
		self.crossValidationClassifier = None
		self.vectorizer = TfidfVectorizer(use_idf=False, stop_words='english')
		#default classifier
		self.classifier = SVC(gamma='scale', kernel='linear')
		#default
		self.transformer = None

	def getVectorizer(self):
		return self.vectorizer

	def getClassifier(self):
		trainvec = self.vectorizer.fit_transform(self.corpora)
		self.classifier.fit(trainvec, self.labels)
		return self.classifier


	def useVectorizerParams(self, idf, ngrams, stopWords, vocab):
		self.vectorizer = TfidfVectorizer(use_idf=idf, ngram_range=ngrams, stop_words=stopWords, vocabulary=vocab)

	def useClassifier(self, csfType):
		if csfType == 'SVC':
			self.classifier = SVC(gamma='scale', kernel='linear')
		elif csfType == 'KNeighborsClassifier':
			self.classifier = KNeighborsClassifier(n_neighbors=3,weights='distance')
		elif csfType == 'Perceptron':
			self.classifier = Perceptron()

	def crossValidation(self):
	    bestClassifier = None
	    scoreMean = 0
	    bestScore = 0
	    iters = 5
	    for i in range(0, iters):
	        # trainCorpora, testCorpora, trainLabels, testLabels = train_test_split(corpora, labels, test_size=0.2)
	        trainCorpora, testCorpora, trainLabels, testLabels = self.splitTrainTest(self.corpora, self.labels, 0.2, i)
	        trainvec = self.vectorizer.fit_transform(trainCorpora)
	        classifier = self.classifier.fit(trainvec, trainLabels)
	        testvec = self.vectorizer.transform(testCorpora)
	        predictions = classifier.predict(testvec)
	        score = metrics.accuracy_score(testLabels, predictions)
	        scoreMean += score
	        if score > bestScore:
	        	bestScore = score
	        	bestClassifier = classifier

	    scoreMean = scoreMean / iters
	    return scoreMean, bestClassifier

	def getCrossValidationScore(self):
		if self.crossValidationScore is None:
			score, csf = self.crossValidation()
			self.crossValidationScore = score
			self.crossValidationClassifier = csf
		return score

	def getCrossValidationClassifier(self):
		if self.crossValidationClassifier is None:
			score, csf = self.crossValidation()
			self.crossValidationScore = score
			self.crossValidationClassifier = csf
		return self.crossValidationClassifier


	#testPos [0 - K-1]
	#testSize [0-1] (percentage)
	def splitTrainTest(self, corpora, labels, testSize, testPos):
	    if len(corpora) != len(labels):
	        print('Size between corpora and labels doesnt match')
	        return -1
	    if testSize > 1 or testSize < 0:
	        print('testSize must be between 0 and 1')
	        return -1
	    if testPos < 0 or testPos > (1/testSize):
	        print('testPos must be between 0 and ', (1/testSize))
	        return -1

	    corporaLength = len(corpora)
	    corpora = corpora.copy()
	    labels = labels.copy()


	    testCorpora = corpora[int(corporaLength * testSize * testPos) : int(corporaLength * testSize * (testPos+1))]
	    testLabels = labels[int(corporaLength * testSize * testPos) : int(corporaLength * testSize * (testPos+1))]
	    for i in range(0, len(testCorpora)):
	        corpora.pop(int(corporaLength * testSize * testPos))
	        labels.pop(int(corporaLength * testSize * testPos))
	    trainCorpora = corpora
	    trainLabels = labels
	    
	    return trainCorpora, testCorpora, trainLabels, testLabels