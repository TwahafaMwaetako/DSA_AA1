import ballerina/grpc;
import ballerina/io;

service "ShoppingService" on new grpc:Listener(9090) {

    // In-memory product storage
    map<Product> products = {};
    map<Cart> carts = {};
    map<string> orders = {};

    // Add a new product by Admin
    remote function AddProduct(Product req) returns ProductResponse {
        products[req.sku] = req;
        return { message: "Product added successfully!", product: req };
    }

    // Stream multiple users (admins or customers)
    remote function CreateUsers(stream<User, CreateUsersResponse> clientStream) returns CreateUsersResponse|error {
        User? user = check clientStream.receive();
        while user is User {
            io:println("Received user: ", user.id, " Role: ", user.role);
            user = check clientStream.receive();
        }
        return { message: "Users created successfully!" };
    }

    // Update product details
    remote function UpdateProduct(Product req) returns ProductResponse {
        if req.sku in products {
            products[req.sku] = req;
            return { message: "Product updated successfully!", product: req };
        }
        return { message: "Product not found", product: {} };
    }

    // Remove a product by Admin
    remote function RemoveProduct(ProductRequest req) returns ProductListResponse {
        if req.sku in products {
            products.remove(req.sku);
            return { products: products.values() };
        }
        return { products: products.values() };
    }

    // List all available products for the customer
    remote function ListAvailableProducts(Empty req) returns ProductListResponse {
        return { products: products.values() };
    }

    // Search product by SKU
    remote function SearchProduct(ProductRequest req) returns ProductResponse {
        if req.sku in products {
            return { message: "Product found", product: products[req.sku] };
        }
        return { message: "Product not available", product: {} };
    }

    // Add product to customer's cart
    remote function AddToCart(AddToCartRequest req) returns CartResponse {
        if req.sku in products {
            carts[req.user_id].add(req.sku);
            return { message: "Product added to cart" };
        }
        return { message: "Product not available" };
    }

    // Place an order
    remote function PlaceOrder(OrderRequest req) returns OrderResponse {
        Product[] cartItems = carts[req.user_id].map((sku) => products[sku]);
        orders[req.user_id] = cartItems;
        carts.remove(req.user_id);
        return { message: "Order placed successfully", products: cartItems };
    }
}

type Cart string[];
