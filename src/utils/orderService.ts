import { apiService } from '../services/api';
import { CartItem } from '../types';

export interface CreateOrderRequest {
  items: CartItem[];
  total: number;
  customerName?: string;
  tableNumber?: number;
}

export interface OrderResponse {
  id: string;
  queueNumber: number;
  status: 'pending' | 'confirmed' | 'preparing' | 'ready' | 'completed';
  total: number;
  estimatedTime?: number;
}

export const orderService = {
  async createOrder(orderData: CreateOrderRequest): Promise<OrderResponse> {
    try {
      const response = await apiService.createOrder(orderData);
      return response;
    } catch (error) {
      console.error('Failed to create order:', error);
      throw new Error('Failed to create order. Please try again.');
    }
  },

  async getOrderStatus(orderId: string): Promise<OrderResponse> {
    try {
      const response = await apiService.getOrderStatus(orderId);
      return response;
    } catch (error) {
      console.error('Failed to get order status:', error);
      throw new Error('Failed to get order status. Please try again.');
    }
  }
};