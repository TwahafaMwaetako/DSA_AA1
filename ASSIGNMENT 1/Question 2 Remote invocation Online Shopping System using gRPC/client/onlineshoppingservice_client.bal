import ballerina/http;
import ballerina/io;

type Product record { // Define the Product record
    string product_id;
    string name;
    string category;
    float price;
    boolean is_available;
};

type AddProductRequest record { // Define the AddProductRequest record
    Product product;
};

type AddProductResponse record { // Define the AddProductResponse record
    string product_id;
};

type User record { // Define the User record
    string user_id;
    string user_type;
};

type CreateUsersRequest record { // Define the CreateUsersRequest record
    User[] users;
    string name;
    string contactNumber;
    string email;
};

type CreateUsersResponse record { // Define the CreateUsersResponse record
    User[] users;
};

type UpdateProductRequest record { // Define the UpdateProductRequest record
    Product product;
};

type UpdateProductResponse record {
    Product updated_product;
};

type RemoveProductResponse record {
    string product_id;
};

type ListAvailableProductsResponse record {
    Product[] products;
};

type SearchProductResponse record {
    Product product;
};

type PlaceOrderRequest record {
    string user_id;
    string product_id;
};

type PlaceOrderResponse record {
    string order_id;
    boolean is_successful;
};

public function main() returns error? { // Main function
    // Set the gRPC service endpoint URL
    string grpcServiceURL = "http://localhost:9090";

    // HTTP client configuration for the gRPC service
    http:Client ep = check new (grpcServiceURL);

    // Display the menu
    io:println("*****Online Shopping System Menu******");
    io:println("1. Add a new Product.");
    io:println("2. Create a new User.");
    io:println("3. Update product information.");
    io:println("4. Search product by ID.");
    io:println("5. Remove product by ID.");
    io:println("6. List available products.");
    io:println("7. Place an order.");
    io:println("8. Exit.");

    // Get the user's choice
    string option = io:readln("Enter your choice (1-8): ");

    match option {
        "1" => {
            // Add a new Product
            AddProductRequest addProductRequest = createAddProductRequest(); // Create the AddProductRequest
            AddProductResponse addProductResponse = addProduct(ep, addProductRequest); // Send the AddProductRequest to the gRPC service and get the response
            handleAddProductResponse(addProductResponse); // Handle the AddProductResponse as needed
        }

        "2" => {
            // Create a new User
            CreateUsersRequest createUsersRequest = createCreateUsersRequest(); // Create the CreateUsersRequest
            CreateUsersResponse createUsersResponse = createUsers(ep, createUsersRequest); // Send the CreateUsersRequest to the gRPC service and get the response
            handleCreateUsersResponse(createUsersResponse); // Handle the CreateUsersResponse as needed
        }

        "3" => {
            // Update product information
            UpdateProductRequest updateProductRequest = createUpdateProductRequest();
            UpdateProductResponse updateProductResponse = updateProduct(ep, updateProductRequest);
            handleUpdateProductResponse(updateProductResponse);
        }

        "4" => {
            // Search product by ID
            string productId = createSearchProductRequest();
            SearchProductResponse searchProductResponse = searchProduct(ep, productId);
            handleSearchProductResponse(searchProductResponse);
        }

        "5" => {
            // Remove product by ID
            string productIdToRemove = createRemoveProductRequest();
            RemoveProductResponse removeProductResponse = removeProduct(ep, productIdToRemove);
            handleRemoveProductResponse(removeProductResponse);
        }

        "6" => {
            // List available products
            ListAvailableProductsResponse listAvailableProductsResponse = listAvailableProducts(ep);
            handleListAvailableProductsResponse(listAvailableProductsResponse);
        }

        "7" => {
            // Place an order
            PlaceOrderRequest placeOrderRequest = createPlaceOrderRequest();
            PlaceOrderResponse placeOrderResponse = placeOrder(ep, placeOrderRequest);
            handlePlaceOrderResponse(placeOrderResponse);
        }

        "8" => {
            // Exit
            io:println("Exiting from the system.");
            return ();
        }

        _ => {
            io:println("Invalid option. Please try again.");
        }
    }
}

function addProduct(http:Client ep, AddProductRequest addProductRequest) returns AddProductResponse|error {
    // Send the addProductRequest to the gRPC service and get the response
    return check ep->post("/addProduct", addProductRequest);
}

function createAddProductRequest() returns AddProductRequest {
    // Get user input or create the AddProductRequest as needed
    AddProductRequest addProductRequest = {
        product: {
            product_id: io:readln("Enter product ID: "),
            name: io:readln("Enter product name: "),
            category: io:readln("Enter product category: "),
            price: io:readln("Enter product price: ").toFloat(),
            is_available: true
        }
    };
    return addProductRequest;
}

function handleAddProductResponse(AddProductResponse addProductResponse) {
    io:println("Product added successfully. Product ID: " + addProductResponse.product_id);
}

function createCreateUsersRequest() returns CreateUsersRequest {
    CreateUsersRequest createUsersRequest = {
        users: [
            {
                user_id: io:readln("Enter user ID: "),
                user_type: io:readln("Enter user type: ")
            }
        ],
        name: io:readln("Enter name: "),
        contactNumber: io:readln("Enter contact number: "),
        email: io:readln("Enter email: ")
    };
    return createUsersRequest;
}

function handleCreateUsersResponse(CreateUsersResponse createUsersResponse) {
    io:println("User(s) created successfully.");
}

function updateProduct(http:Client ep, UpdateProductRequest updateProductRequest) returns UpdateProductResponse|error {
    return check ep->put("/updateProduct", updateProductRequest);
}

function createUpdateProductRequest() returns UpdateProductRequest {
    UpdateProductRequest updateProductRequest = {
        product: {
            product_id: io:readln("Enter product ID: "),
            name: io:readln("Enter product name: "),
            category: io:readln("Enter product category: "),
            price: io:readln("Enter product price: ").toFloat(),
            is_available: io:readln("Is product available? (true/false): ") == "true"
        }
    };
    return updateProductRequest;
}

function handleUpdateProductResponse(UpdateProductResponse updateProductResponse) {
    io:println("Product updated successfully. Product ID: " + updateProductResponse.updated_product.product_id);
}

function createSearchProductRequest() returns string {
    return io:readln("Enter product ID to search: ");
}

function searchProduct(http:Client ep, string productId) returns SearchProductResponse|error {
    return check ep->get("/searchProduct/" + productId);
}

function handleSearchProductResponse(SearchProductResponse searchProductResponse) {
    io:println("Search Result: " + searchProductResponse.product.toString());
}

function createRemoveProductRequest() returns string {
    return io:readln("Enter product ID to remove: ");
}

function removeProduct(http:Client ep, string productId) returns RemoveProductResponse|error {
    return check ep->delete("/removeProduct/" + productId);
}

function handleRemoveProductResponse(RemoveProductResponse removeProductResponse) {
    io:println("Product removed successfully. Product ID: " + removeProductResponse.product_id);
}

function listAvailableProducts(http:Client ep) returns ListAvailableProductsResponse|error {
    return check ep->get("/listAvailableProducts");
}

function handleListAvailableProductsResponse(ListAvailableProductsResponse listAvailableProductsResponse) {
    io:println("Available Products: " + listAvailableProductsResponse.products.toString());
}

function createPlaceOrderRequest() returns PlaceOrderRequest {
    return {
        user_id: io:readln("Enter user ID: "),
        product_id: io:readln("Enter product ID to order: ")
    };
}

function placeOrder(http:Client ep, PlaceOrderRequest placeOrderRequest) returns PlaceOrderResponse|error {
    return check ep->post("/placeOrder", placeOrderRequest);
}

function handlePlaceOrderResponse(PlaceOrderResponse placeOrderResponse) {
    if (placeOrderResponse.is_successful) {
        io:println("Order placed successfully. Order ID: " + placeOrderResponse.order_id);
    } else {
        io:println("Failed to place the order.");
    }
}
