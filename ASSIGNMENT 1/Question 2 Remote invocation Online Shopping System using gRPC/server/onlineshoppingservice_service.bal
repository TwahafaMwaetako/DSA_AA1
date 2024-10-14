import ballerina/grpc;
import ballerina/io;
import ballerina/log;

// Start the program
public function main() returns error? {
    log:printInfo("Starting online shopping system...");
    // The service starts automatically when defined and bound to a listener
    grpc:Listener grpcListener = check new (9090);
    check grpcListener.attach(new ShoppingService());
    log:printInfo("Online shopping system is running on port 9090...");
}

// Record to store product details with required fields
type ProductRecord record {
    string product_id;
    string name;
    string description;
    float price;
    int stock_quantity;
    string SKU;
    boolean is_available;
};

// Request to add a product
type AddProductRequest record {
    UserRecord user;
    ProductRecord product;
};

// Response for adding a product
type AddProductResponse record {
    string message;
    string product_id;
};

// User details record
type UserRecord record {
    string user_id;
    string user_type;
    string name;
    string email;
    string address;
    string contact_number;
};

// Request to remove a product
type RemoveProductRequest record {
    UserRecord user;
    string product_id;
};

// Response for removing a product
type RemoveProductResponse record {
    string message;
    string product_id;
};

// Request to list available products
type ListAvailableProductsRequest record {
    string user_type;
};

// Response for listing available products
type ListAvailableProductsResponse record {
    ProductRecord[] products;
};

// Request to update a product
type UpdateProductRequest record {
    UserRecord user;
    ProductRecord product;
};

// Response for updating a product
type UpdateProductResponse record {
    ProductRecord updated_product;
};

// Order record
type OrderRecord record {
    string order_id;
    string user_id;
    ProductRecord[] products;
};

// Response for placing an order
type PlaceOrderResponse record {
    string message;
    string order_id;
};

// In-memory data stores
map<ProductRecord> productCatalog = {};
map<OrderRecord> orderStore = {};
map<UserRecord> userStore = {};
map<string[]> userCarts = {};

// Define the gRPC service
service class ShoppingService {
    *grpc:Service;

    remote function AddProduct(AddProductRequest value) returns AddProductResponse|error {
        UserRecord? user = userStore[value.user.user_id];
        if user == null {
            return error("User not found with ID: " + value.user.user_id);
        }

        if value.user.user_type == "ADMIN" {
            if productCatalog.hasKey(value.product.product_id) {
                return error("Product already exists with ID: " + value.product.product_id);
            }

            ProductRecord product = {
                product_id: value.product.product_id,
                name: value.product.name,
                description: value.product.description,
                price: value.product.price,
                stock_quantity: value.product.stock_quantity,
                SKU: value.product.SKU,
                is_available: true
            };

            log:printInfo("Product added successfully: ID - " + value.product.product_id + ", Name - " + value.product.name);
            productCatalog[value.product.product_id] = product;
            return {message: "Product added successfully.", product_id: value.product.product_id};
        } else {
            return error("Only admins can add products.");
        }
    }

    remote function RemoveProduct(RemoveProductRequest value) returns RemoveProductResponse|error {
        UserRecord? user = userStore[value.user.user_id];
        if user != null && user.user_type == "ADMIN" {
            ProductRecord? existingProduct = productCatalog[value.product_id];
            if existingProduct == null {
                return error("Product not found with ID: " + value.product_id);
            }
            // Use underscore to ignore the returned value from the remove function
            _ = productCatalog.remove(value.product_id);
            return {message: "Product removed successfully.", product_id: value.product_id};
        } else {
            return error("Only admins can remove products.");
        }
    }

    remote function ListAvailableProducts(ListAvailableProductsRequest value) returns ListAvailableProductsResponse|error {
        ProductRecord[] availableProducts = [];

        // Loop through the entries in the productCatalog map
        foreach var [productId, productRecord] in productCatalog.entries() {
            // Check if the product is available
            if productRecord.is_available {
                availableProducts.push(productRecord);
            }
        }
        return {products: availableProducts};
    }

    remote function UpdateProduct(UpdateProductRequest value) returns UpdateProductResponse|error {
        UserRecord? user = userStore[value.user.user_id];
        if user != null && user.user_type == "ADMIN" {
            ProductRecord? existingProduct = productCatalog[value.product.product_id];
            if existingProduct == null {
                return error("Product not found with ID: " + value.product.product_id);
            }

            existingProduct.name = value.product.name;
            existingProduct.description = value.product.description;
            existingProduct.price = value.product.price;
            existingProduct.stock_quantity = value.product.stock_quantity;
            existingProduct.is_available = value.product.is_available;
            existingProduct.SKU = value.product.SKU;

            productCatalog[value.product.product_id] = existingProduct;
            return {updated_product: existingProduct};
        } else {
            return error("Only admins can update products.");
        }
    }

    remote function AddToCart(string user_id, string product_id) returns string|error {
        ProductRecord? product = productCatalog[product_id];
        if product == null || !product.is_available {
            return error("Product not available.");
        }

        string[] cart = userCarts[user_id] ?: [];
        cart.push(product_id);
        userCarts[user_id] = cart;
        return "Product added to cart.";
    }

    remote function PlaceOrder(string user_id) returns PlaceOrderResponse|error {
        // Retrieve the user's cart
        string[]? cart = userCarts[user_id];
        if cart == null || cart.length() == 0 {
            return error("Cart is empty.");
        }

        // Collect the products from the cart
        ProductRecord[] orderedProducts = [];
        foreach string product_id in cart {
            ProductRecord? product = productCatalog[product_id];
            if product != null {
                orderedProducts.push(product);
            }
        }
    }

    remote function CreateUsers(stream<UserRecord, grpc:Error?> userStream) returns OperationStatus|error {
        UserRecord|grpc:Error? result;
        while (result              = userStream.next()) {
                if (result is UserRecord) {
                    log:printInfo("Received user: " + result.name);
                    userStore[result.user_id] = result;
                } else if (result is grpc:Error) {
                    return error("Error while reading user stream: " + result.message());
                }
            }
            return {success: true, message: "Users created successfully."};
        }
    }

};

// Descriptor for gRPC service
public const string SHOPPING_DESC = "0A0D6C6962726172792E70726F746F22B2010A05736F6C6422310A0464726F6D18022001280952046973626E22310A12437265617465557365727352657175657374121B0A05757365727318012003280B32052E557365725205757365727322120A0B506F7274637572546F4465636F646522104A0A0E416464506F64756374120801200952204D6172744465636F646522103A0A0D506C6163654F72646572120C0A0A506C6163654F726465722208012009522B506C6163654F72646572496412130A0C4C697374506572636561626C6550726F6475637473210C0A057369676E706F647563740801200B522F5369676E506F6475637475655265717565737412110A09616464546F4361727418012009520D416464546F4361727408110A0B506C6163654F7264657218022009520F506C6163654F726465724964120A0B4C6973744F7264657273210C0A0A4C6973744F7264657273220A0A0B4C697374506572636561626C6550726F6475637473220B0A0E536572636870506F6475637412090A0B506F7274637572546F4465636F6465220F0A0A506C6163654F726465720A0A0A506C6163654F7264657222120A096C6973744F7264657273220A0C416464546F436172740C0A0A506C6163654F726465720A0A0A506C6163654F72646572220B0A0B4C6973744F726465727322";
