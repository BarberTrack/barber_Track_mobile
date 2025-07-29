# Configuración de Variables de Entorno

## Descripción
Este proyecto utiliza variables de entorno para manejar configuraciones sensibles como URLs de API y timeouts.

## Configuración

### 1. Crear el archivo .env
Crea un archivo `.env` en la raíz del proyecto con el siguiente contenido:

```env
# API Configuration
API_BASE_URL=https://barbertrack-gateway.up.railway.app/api/v1

# Timeout Configuration (in seconds)
API_CONNECT_TIMEOUT=30
API_RECEIVE_TIMEOUT=30
API_SEND_TIMEOUT=30
```

### 2. Variables disponibles

- **API_BASE_URL**: URL base de la API
- **API_CONNECT_TIMEOUT**: Timeout de conexión en segundos
- **API_RECEIVE_TIMEOUT**: Timeout de recepción en segundos  
- **API_SEND_TIMEOUT**: Timeout de envío en segundos

### 3. Valores por defecto

Si el archivo `.env` no existe o falta alguna variable, se utilizarán los siguientes valores por defecto:

- API_BASE_URL: `https://barbertrack-gateway.up.railway.app/api/v1`
- Todos los timeouts: `30` segundos

## Uso en el código

Las variables se acceden a través de la clase `Environment`:

```dart
import '../config/environment.dart';

// Obtener la URL base
String baseUrl = Environment.apiBaseUrl;

// Obtener timeouts
int connectTimeout = Environment.connectTimeout;
int receiveTimeout = Environment.receiveTimeout;
int sendTimeout = Environment.sendTimeout;
```

## Seguridad

El archivo `.env` está incluido en `.gitignore` para evitar que se suba al repositorio y exponga información sensible. 