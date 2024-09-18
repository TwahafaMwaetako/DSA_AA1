import ballerina/io;

OnlineShoppingServiceClient ep = check new ("http://localhost:9090");

public function main() returns error? {
    Product addProductRequest = {name: "ballerina", description: "ballerina", price: 1, stock_quantity: 1, sku: "ballerina", status: "AVAILABLE"};
    ProductCode addProductResponse = check ep->AddProduct(addProductRequest);
    io:println(addProductResponse);

    Product updateProductRequest = {name: "ballerina", description: "ballerina", price: 1, stock_quantity: 1, sku: "ballerina", status: "AVAILABLE"};
    OperationStatus updateProductResponse = check ep->UpdateProduct(updateProductRequest);
    io:println(updateProductResponse);

    ProductCode removeProductRequest = {sku: "ballerina"};
    ProductList removeProductResponse = check ep->RemoveProduct(removeProductRequest);
    io:println(removeProductResponse);

    Empty listAvailableProductsRequest = {};
    ProductList listAvailableProductsResponse = check ep->ListAvailableProducts(listAvailableProductsRequest);
    io:println(listAvailableProductsResponse);

    ProductCode searchProductRequest = {sku: "ballerina"};
    Product searchProductResponse = check ep->SearchProduct(searchProductRequest);
    io:println(searchProductResponse);

    CartItem addToCartRequest = {user_id: "ballerina", sku: "ballerina", quantity: 1};
    OperationStatus addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    UserId placeOrderRequest = {user_id: "ballerina"};
    OrderStatus placeOrderResponse = check ep->PlaceOrder(placeOrderRequest);
    io:println(placeOrderResponse);

    User createUsersRequest = {user_id: "ballerina", 'type: "CUSTOMER", name: "ballerina", email: "ballerina"};
    CreateUsersStreamingClient createUsersStreamingClient = check ep->CreateUsers();
    check createUsersStreamingClient->sendUser(createUsersRequest);
    check createUsersStreamingClient->complete();
    OperationStatus? createUsersResponse = check createUsersStreamingClient->receiveOperationStatus();
    io:println(createUsersResponse);
}

