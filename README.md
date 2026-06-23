# STEM Shop 

> STEM Shop is a flutter application built to help stem students to buy and sell their products on thier schools to save time and costs.

---

## Overview
STEM Shop is a Flutter mobile app built under the **TF Unions** platform. Students can list products for sale, browse their school's marketplace, submit item requests, and contact sellers directly via WhatsApp.

Each student only sees products and requests from their own school (school-scoped).

---

## Features
- Firebase Authentication (email/password)
- Home screen with school-scoped product feed
- Store screen with filtering system to reach the exact needed product
- seller screnn to monitor and sell you products
- ability to edit the products as a seller
- cart screen to save what you want
- Ability to chat the seller once if you buy several products from him
- Seller order confirmation / decline flow
- Seller listings management (add, edit, mark as sold, delete)
- Item requests (school-scoped or all STEM schools)
- User profile with photo upload

---

## Tech Stack
| Layer | Technology |
|---|---|
| Framework | Flutter |
| State Management | GetX |
| Database | Firebase Firestore |
| Authentication | Firebase Auth |
| Image Storage | Cloudinary |
| Image Picker | image_picker |
| Deep Links | url_launcher |

---

## Project Structure
lib/

├── app.dart

├── main.dart

├── navigation_menu.dart

├── data/

│   ├── repositories/

│   │   ├── authentication_repositories.dart

│   │   ├── products/product_repository.dart

│   │   ├── requests/request_repository.dart

│   │   └── user/user_repository.dart

│   └── services/

│       └── cloudinary_storage_service.dart

├── features/

│   ├── authentication/

│   ├── personalization/

│   │   └── controllers/user_controller.dart

│   └── shop/

│       ├── controllers/

│       │   ├── categories_controller.dart

│       │   ├── home_page_controller.dart

│       │   ├── products_controller.dart

│       │   ├── cart_controller.dart

│       │   ├── order_controller.dart

│       │   ├── seller_order_controller.dart

│       │   └── requests_controller.dart

│       ├── models/

│       │   ├── product_model.dart

│       │   ├── category_model.dart

│       │   ├── request_model.dart

│       │   └── order_model.dart

│       └── screens/

│           ├── home/

│           ├── store/

│           ├── search/

│           ├── product_details/

│           ├── all_products/

│           ├── category/

│           ├── add/

│           └── requests/

└── common/

└── widgets/