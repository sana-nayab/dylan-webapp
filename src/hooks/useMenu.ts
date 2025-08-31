import { useState, useEffect } from 'react';
import { MenuData } from '../types';
import { apiService } from '../services/api';
import { useOfflineStorage } from './useOfflineStorage';

export const useMenu = () => {
  const [menuData, setMenuData] = useState<MenuData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const { cacheMenu, loadCachedMenu } = useOfflineStorage();

  useEffect(() => {
    const loadMenu = async () => {
      try {
        setLoading(true);
        
        // Try to fetch from API
        try {
          const data = await apiService.getMenu();
          setMenuData(data);
          await cacheMenu(data);
          setError(null);
          return;
        } catch (fetchError) {
          console.log('API request failed, trying cache...', fetchError);
        }

        // Fallback to cached menu
        const cachedMenu = await loadCachedMenu();
        if (cachedMenu) {
          setMenuData(cachedMenu);
          setError(null);
        } else {
          setError('No menu data available');
        }
      } catch (err) {
        setError('Failed to load menu');
        console.error('Menu loading error:', err);
      } finally {
        setLoading(false);
      }
    };

    loadMenu();
  }, []);

  return { menuData, loading, error };
};