# Dylan Cafe Ordering System

A complete PWA-based tablet ordering system with offline support, real-time updates, and thermal printer integration.

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   React PWA     │    │  Express API    │    │ Printer Service │
│   (Frontend)    │◄──►│   (Backend)     │◄──►│   (Worker)      │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       ▼                       ▼
         │              ┌─────────────────┐    ┌─────────────────┐
         │              │   PostgreSQL    │    │      Redis      │
         │              │   (Database)    │    │   (Job Queue)   │
         └──────────────┤                 │    └─────────────────┘
                        └─────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker & Docker Compose
- Node.js 18+ (for local development)

### Setup & Run

```bash
# Clone and setup
git clone <repository>
cd manila-ordering-system

# Make setup script executable and run
chmod +x scripts/setup.sh
./scripts/setup.sh

# Start all services
docker-compose up

# Or start in development mode
docker-compose up -d postgres redis
npm run dev:all
```

### Access Points
- **Dylan Cafe PWA**: http://localhost:5173
- **Backend API**: http://localhost:3001
- **Database**: localhost:5432
- **Redis**: localhost:6379

## 📱 PWA Features

### Installation
1. Open http://localhost:5173 on tablet browser
2. Tap "Add to Home Screen" when prompted
3. Launch from home screen for full-screen experience

### Offline Support
- Menu cached with Service Worker
- Cart persisted in IndexedDB
- Orders queued when offline, sync when online
- Graceful offline/online state handling

## 🔌 API Endpoints

### Menu
- `GET /api/menu` - Get complete menu with categories and items
- `GET /api/menu/categories` - Get categories only

### Orders
- `POST /api/orders` - Create new order
- `GET /api/orders/:id` - Get order details
- `PUT /api/orders/:id/status` - Update order status
- `GET /api/orders` - List orders (with filters)

### Payments
- `POST /api/payments/initiate` - Initiate payment (QR code)
- `POST /api/payments/webhook` - Payment provider webhook

## 🖨️ Printer Integration

### Supported Printers
- **USB**: Direct USB connection (ESC/POS compatible)
- **Network**: TCP/IP thermal printers (port 9100)
- **Mock**: Console logging for development

### Configuration
Set printer type in `printer-service/.env`:

```env
PRINTER_TYPE=usb|network|mock
PRINTER_IP=192.168.1.100      # For network printers
PRINTER_PORT=9100             # For network printers
USB_VENDOR_ID=0x04b8          # For USB printers
USB_PRODUCT_ID=0x0202         # For USB printers
```

### Print Job Format
```json
{
  "orderId": "uuid",
  "queueNumber": 37,
  "items": [
    {
      "id": "espresso",
      "name": "Espresso", 
      "quantity": 2,
      "price": 12000,
      "description": "Rich and bold single shot"
    }
  ],
  "total": 24000,
  "timestamp": "2025-01-27T10:30:00Z",
  "customerInfo": {
    "name": "John Doe",
    "table": "Table 5"
  }
}
```

## 🔄 Order Flow

1. **Customer**: Browse menu → Add to cart → Checkout
2. **System**: Create order → Generate queue number → Queue print job
3. **Printer**: Print kitchen ticket (KOT)
4. **Kitchen**: Update status via admin panel
5. **Customer**: Real-time status updates via WebSocket

## 🛠️ Development

### Local Development
```bash
# Start database and Redis
docker-compose up -d postgres redis

# Backend
cd backend
npm install
npm run migrate
npm run seed
npm run dev

# Printer Service
cd printer-service
npm install
npm run dev

# Frontend
npm install
npm run dev
```

### Database Operations
```bash
# Run migrations
cd backend && npm run migrate

# Seed with menu data
cd backend && npm run seed

# Connect to database
docker-compose exec postgres psql -U postgres -d manila_ordering
```

### Testing Printer
```bash
# Test print job
docker-compose exec printer-service node -e "
import('./src/services/PrinterService.js').then(m => {
  const service = new m.PrinterService();
  service.initialize().then(() => service.testPrint());
});
"
```

## 🏪 Production Deployment

### Environment Variables
```env
# Backend
DATABASE_URL=postgresql://user:pass@host:5432/db
REDIS_URL=redis://host:6379
NODE_ENV=production
CORS_ORIGIN=https://yourdomain.com

# Printer Service
PRINTER_TYPE=network
PRINTER_IP=192.168.1.100
PRINTER_PORT=9100
```

### Tablet Kiosk Setup
1. Install PWA on Android tablet
2. Enable kiosk mode: Settings → Device Admin → Kiosk Mode
3. Set Manila app as kiosk app
4. Configure auto-start on boot

## 📊 Monitoring

### Health Checks
- Backend: `GET /health`
- Database: `docker-compose exec postgres pg_isready`
- Redis: `docker-compose exec redis redis-cli ping`

### Logs
```bash
# View all logs
docker-compose logs -f

# Specific service logs
docker-compose logs -f backend
docker-compose logs -f printer-service
```

## 🔧 Troubleshooting

### Common Issues

**Printer not working**:
- Check printer IP/USB connection
- Verify printer supports ESC/POS commands
- Test with mock mode first

**PWA not installing**:
- Ensure HTTPS in production
- Check manifest.json is accessible
- Verify service worker registration

**Orders not syncing**:
- Check Redis connection
- Verify WebSocket connection
- Check network connectivity

### Support
For technical support, check logs and ensure all services are healthy:
```bash
docker-compose ps
docker-compose logs
```