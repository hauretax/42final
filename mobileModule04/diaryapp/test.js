const { MongoClient } = require('mongodb');
const assert = require('assert');

// Connection URI
const MONGO_URL = "mongodb+srv://hauretax:Aze123@cluster0.07odesl.mongodb.net/?retryWrites=true&w=majority&appName=test";

// Collection name
const COLLECTION_NAME = "users";

async function main() {
    const client = new MongoClient(MONGO_URL);

    try {
        // Connect to the MongoDB cluster
        await client.connect();
        console.log("Connected to MongoDB Atlas");

        // Get the database and collection
        const db = client.db();
        const collection = db.collection(COLLECTION_NAME);

        // Example operation: find all documents in the collection
        const documents = await collection.find({}).toArray();
        console.log(documents);
    } catch (e) {
        console.error(`Connection error: ${e}`);
    } finally {
        await client.close();
    }
}

main().catch(console.error);
