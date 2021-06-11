db.events.countDocuments({})

//The total number of events in the collection
db.events.countDocuments({}) 

//The total number of events for the device with ID 8f5844d2-7ab3-478e-8ea7-4ea05ab9052e
db.events.find({}).limit(2).pretty()
db.events.countDocuments({deviceId:'8f5844d2-7ab3-478e-8ea7-4ea05ab9052e'}) 
// there are 240 events with this device id
//The total number of events that came from a Firefox browser and happened on or after April 20th, 2019
db.events.countDocuments({'browser.vendor':"firefox"},{'timestamp' :{$gte: ISODate("2019-04-20T00:00:0.000Z")}})

db.events.countDocuments({$and:[{'browser.vendor':"firefox"},{'timestamp' :{$gte: ISODate("2019-04-20")}}]})
db.events.find({$and:[{'browser.vendor':"chrome"},{'browser.os':"windows"}]}).sort({timestamp:-1}).limit(100).pretty()
