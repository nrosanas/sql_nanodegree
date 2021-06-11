db.events.countDocuments({})

//The total number of events in the collection
db.events.countDocuments({}) 

//The total number of events for the device with ID 8f5844d2-7ab3-478e-8ea7-4ea05ab9052e
db.events.find({}).limit(2).pretty()
db.events.countDocuments({deviceId:'8f5844d2-7ab3-478e-8ea7-4ea05ab9052e'}) 
