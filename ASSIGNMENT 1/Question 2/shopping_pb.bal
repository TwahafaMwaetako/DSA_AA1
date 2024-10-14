import ballerina/grpc;
import ballerina/protobuf;

public const string SHOPPING_DESC = "0A0E73686F7070696E672E70726F746F120873686F7070696E6722B1010A0750726F6475637412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128015205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B7512210A0C69735F617661696C61626C65180620012808520B6973417661696C61626C65221D0A0950726F64756374494412100A03736B751801200128095203736B75223C0A0B50726F647563744C697374122D0A0870726F647563747318012003280B32112E73686F7070696E672E50726F64756374520870726F647563747322070A05456D70747922170A03534B5512100A03736B751801200128095203736B75223C0A045573657212170A07757365725F69641801200128095206757365724964121B0A09757365725F747970651802200128095208757365725479706522350A08436172744974656D12170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B75224A0A054F7264657212170A07757365725F6964180120012809520675736572496412280A056974656D7318022003280B32122E73686F7070696E672E436172744974656D52056974656D7332C3030A0F53686F7070696E675365727669636512340A0A41646450726F6475637412112E73686F7070696E672E50726F647563741A132E73686F7070696E672E50726F64756374494412350A0D55706461746550726F6475637412112E73686F7070696E672E50726F647563741A112E73686F7070696E672E50726F64756374123B0A0D52656D6F766550726F6475637412132E73686F7070696E672E50726F6475637449441A152E73686F7070696E672E50726F647563744C697374123F0A154C697374417661696C61626C6550726F6475637473120F2E73686F7070696E672E456D7074791A152E73686F7070696E672E50726F647563744C69737412310A0D53656172636850726F64756374120D2E73686F7070696E672E534B551A112E73686F7070696E672E50726F6475637412300A09416464546F4361727412122E73686F7070696E672E436172744974656D1A0F2E73686F7070696E672E456D707479122E0A0A506C6163654F72646572120F2E73686F7070696E672E4F726465721A0F2E73686F7070696E672E456D70747912300A0B4372656174655573657273120E2E73686F7070696E672E557365721A0F2E73686F7070696E672E456D7074792801620670726F746F33";

public isolated client class ShoppingServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, SHOPPING_DESC);
    }

    isolated remote function AddProduct(Product|ContextProduct req) returns ProductID|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductID>result;
    }

    isolated remote function AddProductContext(Product|ContextProduct req) returns ContextProductID|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductID>result, headers: respHeaders};
    }

    isolated remote function UpdateProduct(Product|ContextProduct req) returns Product|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Product>result;
    }

    isolated remote function UpdateProductContext(Product|ContextProduct req) returns ContextProduct|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Product>result, headers: respHeaders};
    }

    isolated remote function RemoveProduct(ProductID|ContextProductID req) returns ProductList|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductList>result;
    }

    isolated remote function RemoveProductContext(ProductID|ContextProductID req) returns ContextProductList|grpc:Error {
        map<string|string[]> headers = {};
        ProductID message;
        if req is ContextProductID {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductList>result, headers: respHeaders};
    }

    isolated remote function ListAvailableProducts(Empty|ContextEmpty req) returns ProductList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductList>result;
    }

    isolated remote function ListAvailableProductsContext(Empty|ContextEmpty req) returns ContextProductList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductList>result, headers: respHeaders};
    }

    isolated remote function SearchProduct(SKU|ContextSKU req) returns Product|grpc:Error {
        map<string|string[]> headers = {};
        SKU message;
        if req is ContextSKU {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Product>result;
    }

    isolated remote function SearchProductContext(SKU|ContextSKU req) returns ContextProduct|grpc:Error {
        map<string|string[]> headers = {};
        SKU message;
        if req is ContextSKU {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Product>result, headers: respHeaders};
    }

    isolated remote function AddToCart(CartItem|ContextCartItem req) returns Empty|grpc:Error {
        map<string|string[]> headers = {};
        CartItem message;
        if req is ContextCartItem {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Empty>result;
    }

    isolated remote function AddToCartContext(CartItem|ContextCartItem req) returns ContextEmpty|grpc:Error {
        map<string|string[]> headers = {};
        CartItem message;
        if req is ContextCartItem {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Empty>result, headers: respHeaders};
    }

    isolated remote function PlaceOrder(Order|ContextOrder req) returns Empty|grpc:Error {
        map<string|string[]> headers = {};
        Order message;
        if req is ContextOrder {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Empty>result;
    }

    isolated remote function PlaceOrderContext(Order|ContextOrder req) returns ContextEmpty|grpc:Error {
        map<string|string[]> headers = {};
        Order message;
        if req is ContextOrder {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("shopping.ShoppingService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Empty>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("shopping.ShoppingService/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveEmpty() returns Empty|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <Empty>payload;
        }
    }

    isolated remote function receiveContextEmpty() returns ContextEmpty|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <Empty>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public isolated client class ShoppingServiceProductCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProduct(Product response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProduct(ContextProduct response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceEmptyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendEmpty(Empty response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextEmpty(ContextEmpty response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceProductListCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductList(ProductList response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductList(ContextProductList response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class ShoppingServiceProductIDCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendProductID(ProductID response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextProductID(ContextProductID response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextProductList record {|
    ProductList content;
    map<string|string[]> headers;
|};

public type ContextOrder record {|
    Order content;
    map<string|string[]> headers;
|};

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextProduct record {|
    Product content;
    map<string|string[]> headers;
|};

public type ContextProductID record {|
    ProductID content;
    map<string|string[]> headers;
|};

public type ContextCartItem record {|
    CartItem content;
    map<string|string[]> headers;
|};

public type ContextSKU record {|
    SKU content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type ProductList record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type Order record {|
    string user_id = "";
    CartItem[] items = [];
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type User record {|
    string user_id = "";
    string user_type = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type Product record {|
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = "";
    boolean is_available = false;
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type ProductID record {|
    string sku = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type CartItem record {|
    string user_id = "";
    string sku = "";
|};

@protobuf:Descriptor {value: SHOPPING_DESC}
public type SKU record {|
    string sku = "";
|};

