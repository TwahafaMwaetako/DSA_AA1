import ballerina/uuid;
import ballerinax/kafka;
import ballerinax/mongodb;

configurable string kafkaBootstrapServers = "dsaq2-kafka-1:9092";
configurable string mongodbUrl = "mongodb://dsaq2-mongodb-1:27017";

type CustomerRequest record {
    string shipmentType;
    string pickupLocation;
    string deliveryLocation;
    string[] preferredTimeSlots;
    string firstName;
    string lastName;
    string contactNumber;
};

type DeliveryConfirmation record {
    string trackingNumber;
    string pickupTime;
    string estimatedDeliveryTime;
};

kafka:ConsumerConfig kafkaConsumerConfig = {
    bootstrapServers: kafkaBootstrapServers,
    groupId: "standard_delivery_group",
    topics: ["standard-requests"]
};

kafka:ProducerConfig kafkaProducerConfig = {
    bootstrapServers: kafkaBootstrapServers,
    clientId: "standard_delivery_producer"
};

mongodb:ClientConfig mongoConfig = {
    connection: {url: mongodbUrl}
};

public function main() returns error? {
    kafka:Consumer consumer = check new (kafkaConsumerConfig);
    kafka:Producer producer = check new (kafkaProducerConfig);
    mongodb:Client mongoClient = check new (mongoConfig);

    while true {
        kafka:ConsumerRecord[] records = check consumer->poll(5);
        foreach var record in records {
            CustomerRequest request = check record.value.fromJsonStringWithType();
            DeliveryConfirmation confirmation = check processStandardDelivery(request, mongoClient);
            check producer->send({
                topic: "delivery-confirmations",
                value: confirmation.toJsonString().toBytes()
            });
        }
    }
}

function processStandardDelivery(CustomerRequest request, mongodb:Client mongoClient) returns DeliveryConfirmation|error {
    string trackingNumber = uuid:createType1AsString();
    string pickupTime = request.preferredTimeSlots[0]; // Simplified scheduling logic
    string estimatedDeliveryTime = calculateEstimatedDeliveryTime(pickupTime);

    DeliveryConfirmation confirmation = {
        trackingNumber: trackingNumber,
        pickupTime: pickupTime,
        estimatedDeliveryTime: estimatedDeliveryTime
    };

    check storeDeliverySchedule(confirmation, mongoClient);

    return confirmation;
}

function calculateEstimatedDeliveryTime(string pickupTime) returns string {
    // Simplified logic: assume delivery takes 24 hours
    // In a real-world scenario, this would involve more complex calculations
    return pickupTime; // Placeholder
}

function storeDeliverySchedule(DeliveryConfirmation confirmation, mongodb:Client mongoClient) returns error? {
    mongodb:DatabaseClient db = check mongoClient->getDatabase("logistics_db");
    mongodb:Collection collection = check db->getCollection("standard_delivery_schedules");
    _ = check collection->insertOne(confirmation);
}