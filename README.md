# heyStekGadgetStore

# GadgetStore iOS Application (UIKit)

## Overview

This project is an iOS application built using UIKit that consumes data from a public API (`https://fakestoreapi.com/products`) and presents it in a user-friendly interface. The app mimics a basic shopping experience, allowing users to view a list of products, interact with product details, manage a shopping cart, and complete a checkout flow. The project is created as part of an assignment to demonstrate skills in UIKit, networking, UI design, and state management.

---

## Features Implemented

### 1. API Integration

- The application fetches product data from `https://fakestoreapi.com/products`.
- Uses `URLSession` for making HTTP GET requests.
- Includes proper error handling for failed network calls and invalid responses.
- Parses JSON into Swift models using `Codable`.

### 2. Product Listing Screen

- Displays all fetched products in a grid layout using `UICollectionView` with a custom `UICollectionViewCell`.
- Each cell shows the product’s:
  - Title
  - Description (limited to a few lines for readability)
  - Price
  - Rating (number and count)
  - Product image (downloaded using `URLSession` and displayed asynchronously with caching to prevent flickering)
- Grid layout is responsive and adjusts spacing and sizing based on device size.

### 3. Product Detail Preview

- On tapping a product cell, a modal or push screen opens showing:
  - Full product image
  - Title
  - Complete description
  - Price and rating
- This provides users with more context before adding to cart.

### 4. Cart Management

- Each product has a heart button (symbolizing add/remove to cart).
- Tapping this toggles the product’s cart state.
- The cart icon in the navigation bar shows the number of items currently added to the cart.
- Cart management is handled using a singleton class or in-memory model for state retention.

### 5. Cart Screen

- Accessible by tapping the cart icon in the navigation bar.
- Displays a list of all added items using `UITableView`.
- Each cart item shows title, price, and quantity (default is 1).
- User can remove items from the cart directly in this view.
- Subtotal or total price of all items is shown at the bottom.

### 6. Checkout Flow

- The "Checkout" button at the bottom of the cart screen allows users to simulate purchase.
- On tapping checkout, a confirmation popup is shown with a thank-you message.
- After checkout, the cart is cleared and cart count is reset to zero.

### 7. Error Handling

- All network operations are wrapped with `do-catch` or optional handling.
- Alert dialogs are presented to users if:
  - The API fails to respond
  - Data cannot be parsed
  - Images cannot be loaded
- The app ensures a smooth user experience even in failure scenarios.

---

## Architecture and Design

- Follows MVC (Model-View-Controller) architecture.
- Models: Swift structs conforming to `Codable` for parsing API response.
- Views: Custom UI built entirely with UIKit components.
- Controllers:
  - ProductListViewController: Handles product display.
  - ProductDetailViewController: Handles product preview.
  - CartViewController: Displays cart items and handles checkout.
- Image loading uses background threads to avoid blocking the UI.

---

## Technologies Used

- Swift 5
- UIKit
- URLSession for networking
- Codable for parsing JSON
- UICollectionView for grid layout
- UITableView for cart display
- UINavigationController for app navigation
- UIAlertController for error messages and checkout popup

---

## How to Run the Project

1. Clone the repository using the command:



![Simulator Screenshot - iPhone 16 Pro - 2025-04-18 at 10 31 58](https://github.com/user-attachments/assets/44f45541-01ee-4ec3-b4ea-bd9bec14af13)

