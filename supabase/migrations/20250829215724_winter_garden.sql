/*
  # Manila Beverage Menu 2025 - Seed Data
  
  This file populates the database with the complete menu from the Manila PDF.
  All prices are stored in centavos (multiply by 100 from peso amounts).
  
  Categories:
  1. Coffee (6 items)
  2. Tea & Lemonade (4 items) 
  3. Smoothies (3 items)
  4. Pastries (3 items)
*/

-- Clear existing data
TRUNCATE TABLE order_items, orders, menu_items, categories RESTART IDENTITY CASCADE;

-- Insert categories
INSERT INTO categories (id, name, display_order) VALUES
  ('550e8400-e29b-41d4-a716-446655440001', 'Coffee', 1),
  ('550e8400-e29b-41d4-a716-446655440002', 'Tea & Lemonade', 2),
  ('550e8400-e29b-41d4-a716-446655440003', 'Smoothies', 3),
  ('550e8400-e29b-41d4-a716-446655440004', 'Pastries', 4);

-- Insert Coffee items
INSERT INTO menu_items (id, category_id, name, description, price, image_url, display_order) VALUES
  ('550e8400-e29b-41d4-a716-446655440101', '550e8400-e29b-41d4-a716-446655440001', 'Espresso', 'Rich and bold single shot', 12000, 'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?auto=compress&cs=tinysrgb&w=400', 1),
  ('550e8400-e29b-41d4-a716-446655440102', '550e8400-e29b-41d4-a716-446655440001', 'Doppio', 'Double shot espresso', 15000, 'https://images.pexels.com/photos/983847/pexels-photo-983847.jpeg?auto=compress&cs=tinysrgb&w=400', 2),
  ('550e8400-e29b-41d4-a716-446655440103', '550e8400-e29b-41d4-a716-446655440001', 'Affogato', 'Espresso over vanilla ice cream', 20000, 'https://images.pexels.com/photos/851555/pexels-photo-851555.jpeg?auto=compress&cs=tinysrgb&w=400', 3),
  ('550e8400-e29b-41d4-a716-446655440104', '550e8400-e29b-41d4-a716-446655440001', 'Macchiato', 'Hot or Iced with milk foam', 16500, 'https://images.pexels.com/photos/1557547/pexels-photo-1557547.jpeg?auto=compress&cs=tinysrgb&w=400', 4),
  ('550e8400-e29b-41d4-a716-446655440105', '550e8400-e29b-41d4-a716-446655440001', 'Americano', 'Espresso with hot water', 14000, 'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg?auto=compress&cs=tinysrgb&w=400', 5),
  ('550e8400-e29b-41d4-a716-446655440106', '550e8400-e29b-41d4-a716-446655440001', 'Cappuccino', 'Espresso with steamed milk and foam', 17500, 'https://images.pexels.com/photos/302896/pexels-photo-302896.jpeg?auto=compress&cs=tinysrgb&w=400', 6);

-- Insert Tea & Lemonade items
INSERT INTO menu_items (id, category_id, name, description, price, image_url, display_order) VALUES
  ('550e8400-e29b-41d4-a716-446655440201', '550e8400-e29b-41d4-a716-446655440002', 'Hot Tea', 'Premium Ceylon black tea', 16000, 'https://images.pexels.com/photos/1638280/pexels-photo-1638280.jpeg?auto=compress&cs=tinysrgb&w=400', 1),
  ('550e8400-e29b-41d4-a716-446655440202', '550e8400-e29b-41d4-a716-446655440002', 'Lemon Iced Tea', 'Refreshing iced tea with fresh lemon', 17000, 'https://images.pexels.com/photos/1540258/pexels-photo-1540258.jpeg?auto=compress&cs=tinysrgb&w=400', 2),
  ('550e8400-e29b-41d4-a716-446655440203', '550e8400-e29b-41d4-a716-446655440002', 'Green Tea', 'Antioxidant-rich Japanese sencha', 18000, 'https://images.pexels.com/photos/1417945/pexels-photo-1417945.jpeg?auto=compress&cs=tinysrgb&w=400', 3),
  ('550e8400-e29b-41d4-a716-446655440204', '550e8400-e29b-41d4-a716-446655440002', 'Pink Lemonade', 'Sweet and tangy with fresh berries', 19000, 'https://images.pexels.com/photos/1233319/pexels-photo-1233319.jpeg?auto=compress&cs=tinysrgb&w=400', 4);

-- Insert Smoothie items
INSERT INTO menu_items (id, category_id, name, description, price, image_url, display_order) VALUES
  ('550e8400-e29b-41d4-a716-446655440301', '550e8400-e29b-41d4-a716-446655440003', 'Mango Smoothie', 'Fresh mango with coconut milk', 22000, 'https://images.pexels.com/photos/5945841/pexels-photo-5945841.jpeg?auto=compress&cs=tinysrgb&w=400', 1),
  ('550e8400-e29b-41d4-a716-446655440302', '550e8400-e29b-41d4-a716-446655440003', 'Berry Blast', 'Mixed berries with yogurt', 24000, 'https://images.pexels.com/photos/1346347/pexels-photo-1346347.jpeg?auto=compress&cs=tinysrgb&w=400', 2),
  ('550e8400-e29b-41d4-a716-446655440303', '550e8400-e29b-41d4-a716-446655440003', 'Green Goddess', 'Spinach, apple, and banana blend', 26000, 'https://images.pexels.com/photos/1092730/pexels-photo-1092730.jpeg?auto=compress&cs=tinysrgb&w=400', 3);

-- Insert Pastry items
INSERT INTO menu_items (id, category_id, name, description, price, image_url, display_order) VALUES
  ('550e8400-e29b-41d4-a716-446655440401', '550e8400-e29b-41d4-a716-446655440004', 'Butter Croissant', 'Flaky, buttery French pastry', 18000, 'https://images.pexels.com/photos/2135677/pexels-photo-2135677.jpeg?auto=compress&cs=tinysrgb&w=400', 1),
  ('550e8400-e29b-41d4-a716-446655440402', '550e8400-e29b-41d4-a716-446655440004', 'Blueberry Muffin', 'Fresh blueberries in soft muffin', 16000, 'https://images.pexels.com/photos/2067396/pexels-photo-2067396.jpeg?auto=compress&cs=tinysrgb&w=400', 2),
  ('550e8400-e29b-41d4-a716-446655440403', '550e8400-e29b-41d4-a716-446655440004', 'Cheese Danish', 'Sweet pastry with cream cheese', 20000, 'https://images.pexels.com/photos/1721951/pexels-photo-1721951.jpeg?auto=compress&cs=tinysrgb&w=400', 3);