import ballerina/io;
import ballerina/grpc;
import generated.shopping_pb; // Import the generated gRPC client code

public function main() {
    shopping:ShoppingServiceClient client = check new ("http://localhost:9090");

    // Test AddProduct
    shopping:Product newProduct = {
        name: "Smartphone",
        description: "Latest model smartphone",
        price: 499.99,
        stock_quantity: 20,
        sku: "SMART456",
        is_available: true
    };
    shopping:ProductID productID = check client->addProduct(newProduct);
    io:println("Added Product ID: ", productID.sku);

    // Test ListAvailableProducts
    shopping:Empty req = {};
    shopping:ProductList productList = check client->listAvailableProducts(req);
    io:println("Available Products: ", productList.products);

    // Test SearchProduct
    shopping:SKU skuReq = {sku: "SMART456"};
    shopping:Product product = check client->searchProduct(skuReq);
    io:println("Product Details: ", product);

    // Test UpdateProduct
    shopping:Product updatedProduct = {
        name: "Smartphone Pro",
        description: "Updated model smartphone",
        price: 599.99,
        stock_quantity: 15,
        sku: "SMART456",
        is_available: true
    };
    shopping:Product updatedResponse = check client->updateProduct(updatedProduct);
    io:println("Updated Product: ", updatedResponse);

    // Test RemoveProduct
    shopping:ProductID removeProductID = {sku: "SMART456"};
    shopping:ProductList updatedProductList = check client->removeProduct(removeProductID);
    io:println("Updated Product List: ", updatedProductList.products);
}
