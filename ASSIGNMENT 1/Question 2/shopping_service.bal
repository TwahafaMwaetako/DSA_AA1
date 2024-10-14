import ballerina/grpc;
import ballerina/io;
import generated.shopping_pb as shopping; // Import the generated gRPC code

service "ShoppingService" on new grpc:Listener(9090) {
    shopping:Product[] availableProducts = [];
    map<shopping:CartItem[]> userCarts = [];
    map<shopping:Order[]> userOrders = [];
    
    resource function addProduct(shopping:Product request) returns shopping:ProductID|grpc:Error {
        foreach shopping:Product product in availableProducts {
            if (product.sku == request.sku) {
                return grpc:Error("Product with SKU already exists");
            }
        }
        availableProducts.push(request);
        return {sku: request.sku};
    }

    resource function updateProduct(shopping:Product request) returns shopping:Product|grpc:Error {
        foreach shopping:Product product in availableProducts {
            if (product.sku == request.sku) {
                // Update product details
                int index = availableProducts.indexOf(product);
                availableProducts[index] = request;
                return request;
            }
        }
        return grpc:Error("Product not found");
    }

    resource function removeProduct(shopping:ProductID request) returns shopping:ProductList|grpc:Error {
        shopping:Product[] updatedProducts = [];
        boolean found = false;
        foreach shopping:Product product in availableProducts {
            if (product.sku == request.sku) {
                found = true;
                continue;
            }
            updatedProducts.push(product);
        }
        if (!found) {
            return grpc:Error("Product not found");
        }
        availableProducts = updatedProducts;
        return {products: availableProducts};
    }

    resource function listAvailableProducts(shopping:Empty request) returns shopping:ProductList {
        return {products: availableProducts};
    }

    resource function searchProduct(shopping:SKU request) returns shopping:Product|grpc:Error {
        foreach shopping:Product product in availableProducts {
            if (product.sku == request.sku) {
                return product;
            }
        }
        return grpc:Error("Product not found");
    }

    resource function addToCart(shopping:CartItem request) returns shopping:Empty|grpc:Error {
        if (userCarts.hasKey(request.user_id)) {
            userCarts[request.user_id].push(request);
        } else {
            userCarts[request.user_id] = [request];
        }
        return {};
    }

    resource function placeOrder(shopping:Order request) returns shopping:Empty|grpc:Error {
        if (userOrders.hasKey(request.user_id)) {
            userOrders[request.user_id].push(request);
        } else {
            userOrders[request.user_id] = [request];
        }
        // Clear the cart after placing the order
        userCarts.remove(request.user_id);
        return {};
    }

    resource function createUsers(stream<shopping:User> userStream) returns shopping:Empty {
        // This is just a placeholder; implementation depends on how you want to handle users
        return {};
    }
}
