"""Backend mínimo para la práctica (video FLUTTER_01: conectividad con Docker).

Solo usa la librería estándar de Python, así la imagen de Docker no necesita
instalar dependencias. Expone un único endpoint:

    GET /api/estado  ->  {"estado": "ok", "mensaje": "...", "hora": "..."}
"""

import json
from datetime import datetime
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

PUERTO = 8080


class Manejador(BaseHTTPRequestHandler):
    def _responder(self, codigo, cuerpo):
        datos = json.dumps(cuerpo, ensure_ascii=False).encode("utf-8")
        self.send_response(codigo)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        # CORS: necesario cuando la app Flutter corre en el navegador
        # (flutter run -d chrome), porque el origen es distinto al del backend.
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Content-Length", str(len(datos)))
        self.end_headers()
        self.wfile.write(datos)

    def do_GET(self):
        if self.path == "/api/estado":
            self._responder(200, {
                "estado": "ok",
                "mensaje": "Hola desde el contenedor Docker",
                "hora": datetime.now().strftime("%H:%M:%S"),
            })
        else:
            self._responder(404, {"estado": "error", "mensaje": "Ruta no encontrada"})


if __name__ == "__main__":
    # 0.0.0.0 (y no 127.0.0.1) para que el servidor acepte conexiones que
    # vienen de fuera del contenedor.
    print(f"Backend escuchando en el puerto {PUERTO}", flush=True)
    ThreadingHTTPServer(("0.0.0.0", PUERTO), Manejador).serve_forever()
