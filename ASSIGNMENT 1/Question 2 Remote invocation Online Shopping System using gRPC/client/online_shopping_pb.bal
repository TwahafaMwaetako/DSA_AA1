import ballerina/grpc;
import ballerina/protobuf;

public const string ONLINE_SHOPPING_DESC = "0A156F6E6C696E655F73686F7070696E672E70726F746F120E6F6E6C696E6573686F7070696E6722070A05456D70747922C5010A0750726F6475637412120A046E616D6518012001280952046E616D6512200A0B6465736372697074696F6E180220012809520B6465736372697074696F6E12140A0570726963651803200128025205707269636512250A0E73746F636B5F7175616E74697479180420012805520D73746F636B5175616E7469747912100A03736B751805200128095203736B7512350A0673746174757318062001280E321D2E6F6E6C696E6573686F7070696E672E50726F647563745374617475735206737461747573221F0A0B50726F64756374436F646512100A03736B751801200128095203736B7522770A045573657212170A07757365725F69641801200128095206757365724964122C0A047479706518022001280E32182E6F6E6C696E6573686F7070696E672E557365725479706552047479706512120A046E616D6518032001280952046E616D6512140A05656D61696C1804200128095205656D61696C22450A0F4F7065726174696F6E53746174757312180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676522420A0B50726F647563744C69737412330A0870726F647563747318012003280B32172E6F6E6C696E6573686F7070696E672E50726F64756374520870726F647563747322510A08436172744974656D12170A07757365725F6964180120012809520675736572496412100A03736B751802200128095203736B75121A0A087175616E7469747918032001280552087175616E7469747922210A0655736572496412170A07757365725F69641801200128095206757365724964229F010A0B4F7264657253746174757312190A086F726465725F696418012001280952076F72646572496412160A067374617475731802200128095206737461747573123C0A0D6F7264657265645F6974656D7318032003280B32172E6F6E6C696E6573686F7070696E672E50726F64756374520C6F7264657265644974656D73121F0A0B746F74616C5F7072696365180420012802520A746F74616C50726963652A300A0D50726F64756374537461747573120D0A09415641494C41424C45100012100A0C4F55545F4F465F53544F434B10012A230A085573657254797065120C0A08435553544F4D4552100012090A0541444D494E100132E8040A154F6E6C696E6553686F7070696E675365727669636512440A0A41646450726F6475637412172E6F6E6C696E6573686F7070696E672E50726F647563741A1B2E6F6E6C696E6573686F7070696E672E50726F64756374436F6465220012480A0B437265617465557365727312142E6F6E6C696E6573686F7070696E672E557365721A1F2E6F6E6C696E6573686F7070696E672E4F7065726174696F6E53746174757322002801124B0A0D55706461746550726F6475637412172E6F6E6C696E6573686F7070696E672E50726F647563741A1F2E6F6E6C696E6573686F7070696E672E4F7065726174696F6E5374617475732200124B0A0D52656D6F766550726F64756374121B2E6F6E6C696E6573686F7070696E672E50726F64756374436F64651A1B2E6F6E6C696E6573686F7070696E672E50726F647563744C6973742200124D0A154C697374417661696C61626C6550726F647563747312152E6F6E6C696E6573686F7070696E672E456D7074791A1B2E6F6E6C696E6573686F7070696E672E50726F647563744C697374220012470A0D53656172636850726F64756374121B2E6F6E6C696E6573686F7070696E672E50726F64756374436F64651A172E6F6E6C696E6573686F7070696E672E50726F64756374220012480A09416464546F4361727412182E6F6E6C696E6573686F7070696E672E436172744974656D1A1F2E6F6E6C696E6573686F7070696E672E4F7065726174696F6E537461747573220012430A0A506C6163654F7264657212162E6F6E6C696E6573686F7070696E672E5573657249641A1B2E6F6E6C696E6573686F7070696E672E4F726465725374617475732200620670726F746F33";

public isolated client class OnlineShoppingServiceClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, ONLINE_SHOPPING_DESC);
    }

    isolated remote function AddProduct(Product|ContextProduct req) returns ProductCode|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductCode>result;
    }

    isolated remote function AddProductContext(Product|ContextProduct req) returns ContextProductCode|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/AddProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductCode>result, headers: respHeaders};
    }

    isolated remote function UpdateProduct(Product|ContextProduct req) returns OperationStatus|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OperationStatus>result;
    }

    isolated remote function UpdateProductContext(Product|ContextProduct req) returns ContextOperationStatus|grpc:Error {
        map<string|string[]> headers = {};
        Product message;
        if req is ContextProduct {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/UpdateProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OperationStatus>result, headers: respHeaders};
    }

    isolated remote function RemoveProduct(ProductCode|ContextProductCode req) returns ProductList|grpc:Error {
        map<string|string[]> headers = {};
        ProductCode message;
        if req is ContextProductCode {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/RemoveProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ProductList>result;
    }

    isolated remote function RemoveProductContext(ProductCode|ContextProductCode req) returns ContextProductList|grpc:Error {
        map<string|string[]> headers = {};
        ProductCode message;
        if req is ContextProductCode {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/RemoveProduct", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/ListAvailableProducts", message, headers);
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
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/ListAvailableProducts", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ProductList>result, headers: respHeaders};
    }

    isolated remote function SearchProduct(ProductCode|ContextProductCode req) returns Product|grpc:Error {
        map<string|string[]> headers = {};
        ProductCode message;
        if req is ContextProductCode {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Product>result;
    }

    isolated remote function SearchProductContext(ProductCode|ContextProductCode req) returns ContextProduct|grpc:Error {
        map<string|string[]> headers = {};
        ProductCode message;
        if req is ContextProductCode {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/SearchProduct", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Product>result, headers: respHeaders};
    }

    isolated remote function AddToCart(CartItem|ContextCartItem req) returns OperationStatus|grpc:Error {
        map<string|string[]> headers = {};
        CartItem message;
        if req is ContextCartItem {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OperationStatus>result;
    }

    isolated remote function AddToCartContext(CartItem|ContextCartItem req) returns ContextOperationStatus|grpc:Error {
        map<string|string[]> headers = {};
        CartItem message;
        if req is ContextCartItem {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OperationStatus>result, headers: respHeaders};
    }

    isolated remote function PlaceOrder(UserId|ContextUserId req) returns OrderStatus|grpc:Error {
        map<string|string[]> headers = {};
        UserId message;
        if req is ContextUserId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <OrderStatus>result;
    }

    isolated remote function PlaceOrderContext(UserId|ContextUserId req) returns ContextOrderStatus|grpc:Error {
        map<string|string[]> headers = {};
        UserId message;
        if req is ContextUserId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("onlineshopping.OnlineShoppingService/PlaceOrder", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <OrderStatus>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("onlineshopping.OnlineShoppingService/CreateUsers");
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

    isolated remote function receiveOperationStatus() returns OperationStatus|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <OperationStatus>payload;
        }
    }

    isolated remote function receiveContextOperationStatus() returns ContextOperationStatus|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <OperationStatus>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
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

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextOrderStatus record {|
    OrderStatus content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextProductCode record {|
    ProductCode content;
    map<string|string[]> headers;
|};

public type ContextUserId record {|
    UserId content;
    map<string|string[]> headers;
|};

public type ContextOperationStatus record {|
    OperationStatus content;
    map<string|string[]> headers;
|};

public type ContextProduct record {|
    Product content;
    map<string|string[]> headers;
|};

public type ContextCartItem record {|
    CartItem content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type ProductList record {|
    Product[] products = [];
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type OrderStatus record {|
    string order_id = "";
    string status = "";
    Product[] ordered_items = [];
    float total_price = 0.0;
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type User record {|
    string user_id = "";
    UserType 'type = CUSTOMER;
    string name = "";
    string email = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type ProductCode record {|
    string sku = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type UserId record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type OperationStatus record {|
    boolean success = false;
    string message = "";
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type Product record {|
    string name = "";
    string description = "";
    float price = 0.0;
    int stock_quantity = 0;
    string sku = "";
    ProductStatus status = AVAILABLE;
|};

@protobuf:Descriptor {value: ONLINE_SHOPPING_DESC}
public type CartItem record {|
    string user_id = "";
    string sku = "";
    int quantity = 0;
|};

public enum ProductStatus {
    AVAILABLE, OUT_OF_STOCK
}

public enum UserType {
    CUSTOMER, ADMIN
}

