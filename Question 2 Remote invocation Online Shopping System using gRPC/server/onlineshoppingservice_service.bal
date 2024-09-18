import ballerina/grpc;
import ballerina/io;
import ballerina/log;

// Declare productInventory at the module level
map<Product> productInventory = {};

@grpc:Descriptor {value: ONLINE_SHOPPING_DESC}
service "OnlineShoppingService" on new grpc:Listener(9090) {

    function init() {
        // Load products from the JSON file
        json jsonData = checkpanic io:fileReadJson("products.json");
        
        // Access the "products" key and ensure it's an array
        json productsJson = checkpanic jsonData.products;
        
        if (productsJson is json[]) {
            foreach json productJson in productsJson {
                Product product = checkpanic productJson.cloneWithType(Product);
                string sku = product.sku;
                productInventory[sku] = product;
            }
            log:printInfo("Product inventory loaded from JSON file.");
        } else {
            log:printError("Products data is not in the expected format.");
        }
    }

    remote function AddProduct(Product value) returns ProductCode|error {
        string sku = value.sku;
        productInventory[sku] = value;
        log:printInfo("Product added: " + value.name);
        return {sku: sku};
    }

    remote function UpdateProduct(Product value) returns OperationStatus|error {
        string sku = value.sku;
        if productInventory.hasKey(sku) {
            productInventory[sku] = value;
            return {success: true, message: "Product updated successfully."};
        } else {
            return {success: false, message: "Product not found."};
        }
    }

    remote function RemoveProduct(ProductCode value) returns ProductList|error {
        string sku = value.sku;

        // Check if the product exists in the inventory
        if productInventory.hasKey(sku) {
            // Remove the product from the inventory
            _ = productInventory.remove(sku); // Ignore the return value
        } else {
            return error("Product not found.");
        }

        // Collect all remaining products into a list
        Product[] productsList = [];
        foreach var (key, product) in productInventory {
            productsList.push(product);
        }

        // Return the list of products
        return {products: productsList};
    }

    remote function ListAvailableProducts(Empty value) returns ProductList|error {
        Product[] availableProducts = [];

        // Iterate over the map using 'foreach' and get key-value pairs
        foreach var (sku, product) in productInventory {
            if product.status == ProductStatus::AVAILABLE {
                availableProducts.push(product);
            }
        }

        // Return the list of available products
        return {products: availableProducts};
    }

    remote function SearchProduct(ProductCode value) returns Product|error {
        string sku = value.sku;

        // Check if the product exists in the inventory
        if productInventory.hasKey(sku) {
            return productInventory[sku];
        } else {
            return error("Product not found.");
        }
    }

    remote function AddToCart(CartItem value) returns OperationStatus|error {
        // Add-to-cart logic here...
        return {success: true, message: "Item added to cart."};
    }

    remote function PlaceOrder(UserId value) returns OrderStatus|error {
        // Order placement logic here...
        return {order_id: "ORD001", status: "Processed", ordered_items: [], total_price: 0.0};
    }

    remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns OperationStatus|error {
        // User creation logic here...
        return {success: true, message: "Users created successfully."};
    }
}
