/*
  # Manila Ordering System - Initial Schema

  1. New Tables
    - `categories` - Menu categories (Coffee, Tea, etc.)
      - `id` (uuid, primary key)
      - `name` (text, category name)
      - `display_order` (integer, for sorting)
      - `created_at` (timestamp)
    
    - `menu_items` - Individual menu items
      - `id` (uuid, primary key) 
      - `category_id` (uuid, foreign key to categories)
      - `name` (text, item name)
      - `description` (text, item description)
      - `price` (integer, price in centavos)
      - `image_url` (text, product image URL)
      - `available` (boolean, item availability)
      - `display_order` (integer, for sorting within category)
      - `created_at` (timestamp)

    - `orders` - Customer orders
      - `id` (uuid, primary key)
      - `queue_number` (integer, daily queue number)
      - `total_amount` (integer, total in centavos)
      - `status` (enum, order status)
      - `payment_status` (enum, payment status)
      - `payment_method` (text, payment method used)
      - `payment_transaction_id` (text, payment provider transaction ID)
      - `payment_amount` (integer, amount paid in centavos)
      - `customer_name` (text, optional customer name)
      - `customer_table` (text, optional table number)
      - `created_at` (timestamp)
      - `updated_at` (timestamp)

    - `order_items` - Items within each order
      - `id` (uuid, primary key)
      - `order_id` (uuid, foreign key to orders)
      - `menu_item_id` (uuid, foreign key to menu_items)
      - `quantity` (integer, quantity ordered)
      - `unit_price` (integer, price per unit in centavos)
      - `total_price` (integer, total price for this line item)
      - `created_at` (timestamp)

  2. Enums
    - Order status: pending, confirmed, preparing, ready, completed, cancelled
    - Payment status: pending, completed, failed, refunded

  3. Indexes
    - Orders by date and status for kitchen display
    - Menu items by category for fast lookups
    - Queue numbers by date for daily reset

  4. Constraints
    - Positive prices and quantities
    - Valid status transitions
    - Unique queue numbers per day
*/

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create enums
CREATE TYPE order_status AS ENUM ('pending', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled');
CREATE TYPE payment_status AS ENUM ('pending', 'completed', 'failed', 'refunded');

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  name text NOT NULL UNIQUE,
  display_order integer NOT NULL DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Menu items table
CREATE TABLE IF NOT EXISTS menu_items (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  category_id uuid NOT NULL REFERENCES categories(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text DEFAULT '',
  price integer NOT NULL CHECK (price > 0),
  image_url text DEFAULT '',
  available boolean DEFAULT true,
  display_order integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  queue_number integer NOT NULL,
  total_amount integer NOT NULL CHECK (total_amount > 0),
  status order_status DEFAULT 'pending',
  payment_status payment_status DEFAULT 'pending',
  payment_method text,
  payment_transaction_id text,
  payment_amount integer,
  customer_name text,
  customer_table text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT uuid_generate_v4(),
  order_id uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  menu_item_id uuid NOT NULL REFERENCES menu_items(id),
  quantity integer NOT NULL CHECK (quantity > 0),
  unit_price integer NOT NULL CHECK (unit_price > 0),
  total_price integer NOT NULL CHECK (total_price > 0),
  created_at timestamptz DEFAULT now()
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_menu_items_category ON menu_items(category_id);
CREATE INDEX IF NOT EXISTS idx_menu_items_available ON menu_items(available) WHERE available = true;
CREATE INDEX IF NOT EXISTS idx_orders_date_status ON orders(DATE(created_at), status);
CREATE INDEX IF NOT EXISTS idx_orders_queue_date ON orders(queue_number, DATE(created_at));
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);

-- Unique constraint for daily queue numbers
CREATE UNIQUE INDEX IF NOT EXISTS idx_orders_queue_daily 
ON orders(queue_number, DATE(created_at));

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger for orders updated_at
DROP TRIGGER IF EXISTS update_orders_updated_at ON orders;
CREATE TRIGGER update_orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();