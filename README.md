# Práctica Flutter: navegación, formularios y conexión con Docker

Aplicación pequeña hecha en Flutter que aplica las técnicas de los cinco videos de la actividad (serie FLUTTER_01 a FLUTTER_05 de DevTygers).

## Qué hace la app

- **Inicio**: tarjetas de acceso a cada sección.
- **Edad y signo zodiacal**: eliges tu fecha de nacimiento en un calendario y la app calcula tu edad y tu signo.
- **Índice de masa corporal (IMC)**: formulario con validación de peso y estatura; muestra el IMC y su categoría.
- **Conexión con Docker**: consulta un backend que corre en un contenedor y muestra si la app logró conectarse.
- **Menú lateral (Drawer)** disponible en todas las secciones.

## Qué se aplicó de cada video

| Video | Técnica | Dónde está en el código |
|---|---|---|
| FLUTTER_01 Conectividad con Docker | Backend en contenedor, puerto publicado, URL según la plataforma (`10.0.2.2` en emulador Android) | `docker-compose.yml`, `backend/`, `lib/config/api_config.dart`, `lib/services/api_service.dart`, `lib/screens/conexion_screen.dart` |
| FLUTTER_02 Aplicación frontend desde cero | `main()`, `runApp`, `MaterialApp`, `Scaffold`, `AppBar`, widgets Stateless y Stateful | `lib/main.dart`, `lib/screens/home_screen.dart` |
| FLUTTER_03 Estructura y navegación eficiente | Proyecto separado por carpetas y rutas con nombre centralizadas | `lib/routes/app_routes.dart` y la organización de `lib/` |
| FLUTTER_04 Navegación con Drawer | `Drawer`, `DrawerHeader`, `ListTile`, `pushReplacementNamed` | `lib/widgets/app_drawer.dart` |
| FLUTTER_05 Navegación y formularios básicos | `Form`, `TextFormField`, validadores, `showDatePicker`, `setState`, paso de datos entre pantallas | `lib/screens/edad_screen.dart`, `lib/screens/imc_screen.dart`, `lib/screens/resultado_screen.dart`, `lib/utils/calculos.dart` |

Cada archivo tiene comentarios que explican la solución y de qué video viene.

## Estructura del proyecto

```
lib/
  main.dart                 Punto de entrada y MaterialApp
  config/api_config.dart    URL del backend según la plataforma
  routes/app_routes.dart    Rutas con nombre
  screens/                  Una pantalla por archivo
  services/api_service.dart Peticiones HTTP
  utils/calculos.dart       Lógica de edad, signo e IMC
  widgets/app_drawer.dart   Menú lateral reutilizable
test/calculos_test.dart     Pruebas unitarias de la lógica
backend/                    Servidor Python + Dockerfile
docker-compose.yml          Levanta el backend
```

## Requisitos

- [Flutter](https://docs.flutter.dev/get-started/install) 3.19 o superior (`flutter --version`)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (solo para la pantalla de conexión)
- Un emulador Android, un simulador iOS o Chrome

## Cómo ejecutar

1. Clona el repositorio y entra a la carpeta:

   ```bash
   git clone https://github.com/TU_USUARIO/flutter_practica.git
   cd flutter_practica
   ```

2. Descarga las dependencias:

   ```bash
   flutter pub get
   ```

   Si en la carpeta no existen `android/`, `ios/` o `web/`, genéralas con:

   ```bash
   flutter create --project-name flutter_practica .
   ```

3. Levanta el backend en Docker (en otra terminal, déjala abierta):

   ```bash
   docker compose up --build
   ```

   Para comprobarlo, abre <http://localhost:8080/api/estado> en el navegador: debe responder un JSON con `"estado": "ok"`.

4. Ejecuta la app:

   ```bash
   flutter run            # emulador o dispositivo conectado
   flutter run -d chrome  # navegador
   ```

Las pantallas de edad e IMC funcionan sin Docker. Si el backend está apagado, la pantalla de conexión muestra "Sin conexión" y un botón para reintentar.

### Dirección del backend según dónde corre la app

| Dónde corre la app | URL que usa | Configuración |
|---|---|---|
| Emulador Android | `http://10.0.2.2:8080` | Automática |
| Simulador iOS, Chrome, escritorio | `http://localhost:8080` | Automática |
| Celular físico | IP del computador en la red WiFi | `flutter run --dart-define=API_URL=http://192.168.1.20:8080` |

En un celular físico, el celular y el computador deben estar en la misma red WiFi.

## Cómo probar

Pruebas unitarias de la lógica:

```bash
flutter test
```

Prueba manual sugerida:

1. Abre el menú lateral y entra a cada sección.
2. En **Edad y signo**, elige una fecha y pulsa *Calcular*. Vuelve con la flecha.
3. En **IMC**, pulsa *Calcular* con los campos vacíos (deben aparecer los errores) y luego con 70 kg y 175 cm (resultado: 22.9, peso normal).
4. En **Conexión con Docker**, verifica el mensaje *Conectado*. Detén Docker, pulsa *Probar de nuevo* y verifica *Sin conexión*.

## Nota para compilar en modo release en Android

En modo debug Flutter ya incluye el permiso de internet. Para un APK release, agrega esta línea a `android/app/src/main/AndroidManifest.xml`, antes de `<application>`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
```
