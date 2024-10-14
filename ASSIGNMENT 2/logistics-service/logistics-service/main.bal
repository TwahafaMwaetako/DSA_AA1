import ballerina/http;
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

kafka:ProducerConfig kafkaProducerConfig = {
    bootstrapServers: kafkaBootstrapServers,
    clientId: "logistics_producer"
};

kafka:ConsumerConfig kafkaConsumerConfig = {
    bootstrapServers: kafkaBootstrapServers,
    groupId: "logistics_group",
    topics: ["delivery-confirmations"]
};

mongodb:ClientConfig mongoConfig = {
    connection: {url: mongodbUrl}
};

service / on new http:Listener(8080) {
    private final kafka:Producer kafkaProducer;
    private final kafka:Consumer kafkaConsumer;
    private final mongodb:Client mongoClient;

    function init() returns error? {
        self.kafkaProducer = check new (kafkaProducerConfig);
        self.kafkaConsumer = check new (kafkaConsumerConfig);
        self.mongoClient = check new (mongoConfig);
        _ = start self.consumeDeliveryConfirmations();
    }

    resource function post request(@http:Payload CustomerRequest req) returns http:Accepted|error {
        check self.kafkaProducer->send({
            topic: req.shipmentType + "-requests",
            value: req.toJsonString().toBytes()
        });
        return http:ACCEPTED;
    }

    resource function get confirmation/[string trackingNumber]() returns DeliveryConfirmation|http:NotFound|error {
        mongodb:DatabaseClient db = check check self.mongoClient->getDatabase("logistics_db");
        mongodb:Collection collection = check db->getCollection("confirmations");
        map<json> filter = {"trackingNumber": trackingNumber};
        map<json>? result = check collection->findOne(filter);
        if result is () {
            return http:NOT_FOUND;
        }
        return check result.cloneWithType();
    }

    function consumeDeliveryConfirmations() returns error? {
        while true {
            kafka:ConsumerRecord[] records = check self.kafkaConsumer->poll(5);
            foreach var record in records {
                DeliveryConfirmation confirmation = check record.value.fromJsonStringWithType();
                check self.storeConfirmation(confirmation);
            }
        }
    }

    function storeConfirmation(DeliveryConfirmation confirmation) returns error? {
        mongodb:DatabaseClient db = check self.mongoClient->getDatabase("logistics_db");
        mongodb:Collection collection = check db->getCollection("confirmations");
        _ = check collection->insertOne(confirmation);
    }
}