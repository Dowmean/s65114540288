-- PostgreSQL schema converted from MySQL hiwmai.sql
-- Only table structures are included, no data inserts

-- Table: users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    firebase_uid VARCHAR(255) NOT NULL UNIQUE,
    first_name VARCHAR(255),
    gender VARCHAR(10) CHECK (gender IN ('ชาย','หญิง','อื่นๆ')),
    birth_date DATE,
    email VARCHAR(255) UNIQUE,
    profile_picture BYTEA,
    role VARCHAR(10) NOT NULL CHECK (role IN ('User','Recipient','Admin')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: addresses
CREATE TABLE addresses (
    id SERIAL PRIMARY KEY,
    firebase_uid VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    province VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    address_detail TEXT NOT NULL,
    district VARCHAR(100),
    subdistrict VARCHAR(100) NOT NULL,
    city VARCHAR(100),
    postal_code VARCHAR(10),
    is_default BOOLEAN DEFAULT FALSE,
    address_type VARCHAR(10) DEFAULT 'บ้าน' CHECK (address_type IN ('บ้าน','ที่ทำงาน','อื่นๆ')),
    CONSTRAINT fk_addresses_firebase_uid FOREIGN KEY (firebase_uid) REFERENCES users(firebase_uid) ON DELETE CASCADE
);

-- Table: admins
CREATE TABLE admins (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_admins_user_id FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Table: bank_accounts
CREATE TABLE bank_accounts (
    id SERIAL PRIMARY KEY,
    firebase_uid VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    fullname VARCHAR(50) NOT NULL,
    banknumber VARCHAR(20) NOT NULL,
    bankname VARCHAR(50) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_bank_accounts_firebase_uid FOREIGN KEY (firebase_uid) REFERENCES users(firebase_uid) ON DELETE CASCADE
);

-- Table: chats
CREATE TABLE chats (
    id SERIAL PRIMARY KEY,
    sender_email VARCHAR(255) NOT NULL,
    receiver_email VARCHAR(255) NOT NULL,
    message TEXT,
    image_url VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chats_sender_email FOREIGN KEY (sender_email) REFERENCES users(email),
    CONSTRAINT fk_chats_receiver_email FOREIGN KEY (receiver_email) REFERENCES users(email)
);

-- Table: product
CREATE TABLE product (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    email VARCHAR(255),
    category VARCHAR(255),
    productName VARCHAR(255),
    productDescription TEXT,
    price NUMERIC(10,2),
    imageUrl BYTEA,
    postedDate TIMESTAMP,
    shipping NUMERIC(10,2) NOT NULL DEFAULT 0.00,
    carry NUMERIC(10,2) NOT NULL DEFAULT 0.00
);

-- Table: favorites
CREATE TABLE favorites (
    email VARCHAR(255) NOT NULL,
    product_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_email_product UNIQUE (email, product_id),
    CONSTRAINT fk_favorites_product_id FOREIGN KEY (product_id) REFERENCES product(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Table: notifications
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: orders
CREATE TABLE orders (
    ref VARCHAR(20) PRIMARY KEY,
    email VARCHAR(100) NOT NULL,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    total NUMERIC(10,2) NOT NULL,
    shopdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    qrcode BYTEA,
    image BYTEA,
    paydate TIMESTAMP,
    status VARCHAR(50),
    num INTEGER NOT NULL,
    note VARCHAR(255),
    product_id INTEGER NOT NULL,
    CONSTRAINT fk_orders_email FOREIGN KEY (email) REFERENCES users(email)
);

-- Table: payment
CREATE TABLE payment (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255),
    income NUMERIC(10,2),
    datepay TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reference_number VARCHAR(20),
    CONSTRAINT fk_payment_email FOREIGN KEY (email) REFERENCES users(email)
);

-- Table: purchase
CREATE TABLE purchase (
    ref VARCHAR(20) PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    trackingnumber VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    confirm_order BOOLEAN DEFAULT FALSE
);

-- Table: recipients
CREATE TABLE recipients (
    id SERIAL PRIMARY KEY,
    firebase_uid VARCHAR(255),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    title VARCHAR(10) CHECK (title IN ('นางสาว','นาย','นาง')),
    phone_number VARCHAR(20),
    address TEXT,
    bank_name VARCHAR(20) CHECK (bank_name IN ('กรุงไทย','กรุงเทพ','กสิกรไทย','ไทยพาณิชย์','ธนชาต','ออมสิน')),
    account_name VARCHAR(100),
    account_number VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: reviews
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY,
    ref VARCHAR(20) NOT NULL,
    email VARCHAR(255) NOT NULL,
    rate INTEGER NOT NULL CHECK (rate BETWEEN 1 AND 5),
    description VARCHAR(255),
    CONSTRAINT fk_reviews_email FOREIGN KEY (email) REFERENCES users(email) ON DELETE CASCADE
);

INSERT INTO users (firebase_uid, first_name, email, role)
VALUES 
  ('TE2vBcHFkgaIE6r5f2SoQAynsIo1', 'Admin', 'admin@gmail.com', 'Admin'),
  ('eOJ66eKIijhbF6XMj4GRXv1aZLr2', 'TestUser', 'qw@gmail.com', 'User'),
  ('yUiBpsYHfxNoYFxzpsneqKINHhK2', 'Supawadee', 'supawadee@example.com', 'User');

-- Data for table: addresses
INSERT INTO addresses (id, firebase_uid, email, province, name, phone, address_detail, district, subdistrict, city, postal_code, is_default, address_type) VALUES
  (2, 'TE2vBcHFkgaIE6r5f2SoQAynsIo1', 'admin@gmail.com', '23', 'na', '09876543', '12134', '3410', 'ห้วยข่า', NULL, '34230', FALSE, 'บ้าน'),
  (3, 'eOJ66eKIijhbF6XMj4GRXv1aZLr2', '', '7', 'siriii', '08269742', 'ee', '1602', 'มะนาวหวาน', NULL, '15140', TRUE, 'บ้าน'),
  (4, 'eOJ66eKIijhbF6XMj4GRXv1aZLr2', 'qw@gmail.com', '8', 'ttt', '59855', 'tt', '1702', 'สิงห์', NULL, '16130', FALSE, 'อื่นๆ'),
  (5, 'yUiBpsYHfxNoYFxzpsneqKINHhK2', '', '1', 'สุภาวดี มณีรัตน์', '0811234567', '123 / 3 หมู่บ้านคนใจดี ', '1007', 'วังใหม่', NULL, '10330', TRUE, 'บ้าน');

-- Data for table: bank_accounts
INSERT INTO bank_accounts (id, firebase_uid, email, fullname, banknumber, bankname, is_default) VALUES
  (1, 'eOJ66eKIijhbF6XMj4GRXv1aZLr2', 'qw@gmail.com', 'คิวฮา ดอทคอม', '123456789', 'กสิกรไทย (KBank)', FALSE),
  (4, 'eOJ66eKIijhbF6XMj4GRXv1aZLr2', 'qw@gmail.com', 'fiudg ijpuo', '3365894', 'ไทยพาณิชย์ (SCB)', TRUE);
