extends Node

func saveHighScore(level:String,current_score:int) -> void:
	# Variables to use
	var user_id = str(UserPreferences.get_auth_localid())  # Get the authenticated user ID as string
	
	var collection: FirestoreCollection = Firebase.Firestore.collection("Users")  # Reference to Firestore 'Users' collection
	
	# Fetch the user's document
	var task = await collection.get_doc(user_id)
	
	# Check if the document exists
	if task.document:
		var document = task.document
		
		# Check if the level score exists in the document, otherwise set it to 0
		var saved_score = 0
		if document.has(level):
			var lastScore = int(document.get(level)["integerValue"]) 
			print(lastScore)
			saved_score = int(lastScore)
		# Compare the current score with the saved score
		if current_score >= saved_score:
			# Update the score in Firestore
			var document2 = task
			document2.add_or_update_field(level, current_score)
			var new_document_update = await collection.update(document2) 
			 
		else:
			print("Current score is less than saved score, no update needed.")
	else:
		print("No document found for user ID: ", user_id)


 

func unlockLevel() -> Array:
	# Variables to use
	var user_id = str(UserPreferences.get_auth_localid())  # Get the authenticated user ID as string
	var collection: FirestoreCollection = Firebase.Firestore.collection("Users")  # Reference to Firestore 'Users' collection
	# Fetch the user's document
	var task = await collection.get_doc(user_id)
	
	# Check if the document exists
	if task.document:
		var document = task.document
		
		# Initialize an empty array to store unlocked levels
		var unlocked_levels = []
		
		# Check for specific levels and append them if they exist
		if document.has("level1"):
			unlocked_levels.append("level1")
		if document.has("level2"):
			unlocked_levels.append("level2")
		if document.has("level3"):
			unlocked_levels.append("level3")
		# Add checks for more levels as needed...
		
		print("Unlocked levels: ", unlocked_levels)
		return unlocked_levels
	else:
		print("No document found for user ID: ", user_id)
		return []
		
		

 
 


# Initialize dictionaries for each level
var level1CorrectDict = {}
var level2CorrectDict = {}
var level3CorrectDict = {}

var level1ProblemDict = {}
var level2ProblemDict = {}
var level3ProblemDict = {}

# Function to fetch all questions and categorize them by level
func getQuestionAccordingToLevel() -> void:
	if not level1CorrectDict.is_empty():
		return
	
	var db = Firebase.Firestore
	var query: FirestoreQuery = FirestoreQuery.new().from("questions")
	var query_results = await Firebase.Firestore.query(query)
	
	print("GETTING QUESTIONS")
	
	# Check if there are any documents returned
	if query_results.size() > 0:
		# Iterate through all the documents (questions)
		for result in query_results:
			print("PKKKKK")
			var doc_name = result['doc_name']
			var document = result["document"]
			
			# Retrieve question, options, answer, and level fields
			var question = document["question"]["stringValue"]  # 'question' field in Firestore
			var options = []  # Create an empty array to store the options as strings
			
			# Loop through each option to extract stringValue
			for option in document["options"]["arrayValue"]["values"]:
				options.append(option["stringValue"])
			
			var answer = document["answer"]["stringValue"]  # 'answer' field in Firestore
			var level = document["level"]["stringValue"]  # 'level' field in Firestore
			
			print("Level fetched: ", level)

			# Categorize questions and answers into the correct level dictionaries
			match level:
				"1":
					level1CorrectDict[question] = answer
					level1ProblemDict[question] = options
				"2":
					level2CorrectDict[question] = answer
					level2ProblemDict[question] = options
				"3":
					level3CorrectDict[question] = answer
					level3ProblemDict[question] = options
				_:
					print("Unrecognized level: ", level)
		
		# Print to confirm the dictionaries are populated correctly
		print("Level 1 Correct Dictionary: ", level1CorrectDict)
		print("Level 1 Problem Dictionary: ", level1ProblemDict)
		print("Level 2 Correct Dictionary: ", level2CorrectDict)
		print("Level 2 Problem Dictionary: ", level2ProblemDict)
		print("Level 3 Correct Dictionary: ", level3CorrectDict)
		print("Level 3 Problem Dictionary: ", level3ProblemDict)
	else:
		print("No questions found in the collection.")



#
	#if query_results.size() > 0:
		#for result in query_results:
			#print(str(result))
			#var doc_name = result['doc_name']
			#var document = result["document"]
			#var userData = Users.new(doc_name, document)
			#
			#if (userData.id == userId or email == userData.email):
				#
				#user = userData
				#
				#var collection2: FirestoreCollection = Firebase.Firestore.collection(collection_name)
				##var query2: FirestoreQuery = FirestoreQuery.new().from(collection_name)
				##var document2 = await Firebase.Firestore.query(query.get_doc("MSkKBOGzhjVmWssM2t5z6mNAOf33")	)
				###var document2 = await Firebase.Firestore.query(query.get_doc("MSkKBOGzhjVmWssM2t5z6mNAOf33")	)
				##print("highest_score<<<< "+ str(int(user.highest_score_lvl_1)) +"  score: "+str( int(score)))
				#if (level == 1) :
					#
					#if (str(user.highest_score_lvl_1).is_empty() or (int(user.highest_score_lvl_1) < int(score))) :
						#var document2 = await collection2.get_doc(userId)
						#print("getCurrentUser.sendscore....document2: "+str(document2))
						#document2.add_or_update_field("highest_score_lvl_1", score)
						#var new_document_update = await collection2.update(document2) 
						#print("newdocupdate....."+str(new_document_update))
					#else: 
						#print("newdocupdate.....notupdated.....")
				##document.add_or_update_field("highest_score", score)
				##var new_document = await query2.document(userId).update(document)
				##var new_document = await query.document(userId).update(dataDict)
				#elif (level == 2) :
					#
					#if (str(user.highest_score_lvl_2).is_empty() or (int(user.highest_score_lvl_2) < int(score))) :
						#var document2 = await collection2.get_doc(userId)
						#print("document2: "+str(document2))
						#document2.add_or_update_field("highest_score_lvl_2", score)
						#var new_document_update = await collection2.update(document2) 
						#print("newdocupdate....."+str(new_document_update))
					#else: 
						#print("newdocupdate.....notupdated.....")
				#
				#print("getCurrentUser.sendscore.final.....userData.id: "+str(userData.id) +
			#"   userId::"+userId)
				#break
