# Guion de demostracion de la app

**Meta:** 25 minutos para la exposicion de la aplicacion. La introduccion de aproximadamente 7 minutos va aparte; el total previsto es de unos 32 minutos. Ensaya con cronometro y usa las marcas de tiempo como limites, no como lectura obligatoria.

## Antes de iniciar

- Inicia backend, frontend y base de datos local; comprueba la conexion y deja abierta la pantalla de acceso.
- Completa las cuentas de prueba en `credenciales_demo.local.txt`. Hay 11 espacios: administrador, seis estudiantes, responsable, tutor academico, tutor empresarial y un coordinador. Un solo coordinador basta para demostrar el filtro de su carrera; agrega coordinadores solo si decides mostrar mas de una carrera.
- Verifica que tres estudiantes tengan las practicas completadas y tres tengan registros con practicas aun en proceso. Para la presentacion inicia sesion solo con un caso de cada tipo.
- No desactives cuentas ni sobrescribas asignaciones necesarias para los siguientes flujos. Si vas a guardar cambios durante el ensayo, usa un registro local reservado y respalda la base de datos.
- Deja preparados los archivos fuente que mostraras en VS Code. Mantén el codigo en bloques breves, dentro del tiempo de cada rol.

## Cronometro: 25 minutos

| Tiempo | Duracion | Rol y demostracion | Guion oral y codigo |
|---|---:|---|---|
| 00:00-01:00 | 1 min | Acceso y recorrido | «Ahora presentare el sistema en funcionamiento desde los perfiles que intervienen en el proceso de practicas». Inicia sesion como administrador y ubica el panel. |
| 01:00-09:00 | 8 min | Administrador | Muestra usuarios, empresas y gestion academica (carreras, semestres, paralelos, periodos y carreras-periodos). Haz un CRUD completo y breve sobre un registro seguro: crear, editar y desactivar; en los otros modulos enseña listado y estado. Abre el perfil al final. Reserva hasta 2 minutos para explicar `features/admin/presentation/screens` y el recorrido Flutter datasource/repositorio -> API Django `urls.py` -> `views.py`/serializers -> modelos. |
| 09:00-14:00 | 5 min | Dos estudiantes | En el estudiante en proceso muestra inicio, registros/asistencia, bitacora e historial/avance. Cambia al estudiante con practicas completadas y muestra su historial o reporte como contraste. «El mismo flujo permite observar un proceso activo y otro que ya alcanzo su meta». Indica `features/estudiantes/presentation/screens` y `backend/bitacoras/views.py`. |
| 14:00-18:00 | 4 min | Tutor academico | Inicia sesion y muestra estudiantes tutorizados, seguimiento y el detalle de un estudiante; enseña visita o reporte si ya hay datos preparados. Relaciona `features/tutores/presentation/screens` con `backend/usuarios/views.py`, endpoint `tutor-academico/mis-tutoriados/` y las rutas de visitas en `backend/bitacoras/urls.py`. |
| 18:00-21:00 | 3 min | Responsable de practicas | Muestra lista de asignaciones y abre el formulario para explicar como se vinculan estudiante, carrera, empresa y tutores. Guarda una asignacion solo si tienes un registro local reservado; si no, muestra una asignacion ya existente y el formulario sin sobrescribir datos. Codigo: `features/responsable_practicas/presentation/screens/asignaciones` y endpoint `responsable-practicas/datos/` en `backend/usuarios/urls.py`. |
| 21:00-23:00 | 2 min | Tutor empresarial | Muestra sus pasantes asignados y el seguimiento disponible (actividades, visitas o reportes que tengan datos). Explica que la vista depende del usuario autenticado y sus asignaciones. Codigo: `InicioTutorEmpresarialScreen` en `features/tutores/presentation/screens/inicio_tutores_screen.dart` y endpoint `tutor-empresarial/mis-pasantes/` en `backend/usuarios/urls.py`. |
| 23:00-25:00 | 2 min | Coordinador y cierre | Muestra estudiantes y datos academicos de la carrera asignada; confirma visualmente que no aparecen estudiantes de otra carrera. No cambies ese filtro. Codigo: `features/coordinador/presentation/screens` y `CoordinadorDatosView` en `backend/usuarios/views.py`. Cierra con una frase que resuma como los roles colaboran en el seguimiento de las practicas. |

**Comprobacion:** 1 + 8 + 5 + 4 + 3 + 2 + 2 = 25 minutos.

## Preparacion del codigo

En vez de navegar carpetas al azar, muestra un ejemplo de cada capa ligado a la pantalla que acabas de usar:

- Flutter: `frontend/bitacoras_app/lib/features/<modulo>/presentation/screens` contiene pantallas; `data` conecta repositorios y fuentes remotas; `domain` define modelos y contratos.
- Django: `backend/<app>/urls.py` declara rutas; `views.py` procesa solicitudes; `serializers.py` transforma/valida datos; `models.py` define entidades y relaciones.
- Accesos clave: `backend/gestion_academica/urls.py`, `backend/empresas/urls.py`, `backend/usuarios/urls.py` y `backend/bitacoras/urls.py`.
- Roles definidos para la app: `frontend/bitacoras_app/lib/features/inicio/domain/models/rol_usuario_model.dart`.

## Ensayo con cronometro

Haz primero un ensayo sin detenerte para medir el tiempo real. Inicia el cronometro al comenzar el acceso y registra una vuelta al terminar cada bloque. Anota esos tiempos en esta tabla. Haz un segundo ensayo con las mismas cuentas y pantallas; el objetivo es terminar la app entre 25 y 28 minutos y conservar margen hasta el limite de 30.

| Bloque | Meta | Ensayo 1 | Ensayo 2 | Ajuste |
|---|---:|---:|---:|---|
| Acceso y encuadre | 1:00 | | | |
| Administrador | 8:00 | | | |
| Estudiantes | 5:00 | | | |
| Tutor academico | 4:00 | | | |
| Responsable | 3:00 | | | |
| Tutor empresarial | 2:00 | | | |
| Coordinador/cierre | 2:00 | | | |
| **Total app** | **25:00** | | | |

Si superas 30 minutos, acorta la explicacion oral de modulos secundarios del administrador y deja solo un CRUD detallado; conserva al menos una evidencia de cada rol. Si terminas antes de 25, amplia el flujo principal del estudiante en proceso o explica con mas detalle una llamada de frontend a backend, sin agregar operaciones riesgosas a los datos.

## Referencias para abrir durante la defensa

- [Roles Flutter](../frontend/bitacoras_app/lib/features/inicio/domain/models/rol_usuario_model.dart)
- [Rutas principales Flutter](../frontend/bitacoras_app/lib/app/routes/app_router.dart)
- [Pantallas de administracion](../frontend/bitacoras_app/lib/features/admin/presentation/screens)
- [Pantallas de estudiantes](../frontend/bitacoras_app/lib/features/estudiantes/presentation/screens)
- [Pantallas de tutores](../frontend/bitacoras_app/lib/features/tutores/presentation/screens)
- [Pantallas de responsable](../frontend/bitacoras_app/lib/features/responsable_practicas/presentation/screens)
- [Pantallas de coordinador](../frontend/bitacoras_app/lib/features/coordinador/presentation/screens)
- [Rutas de usuarios y perfiles](../backend/usuarios/urls.py)
- [Rutas academicas](../backend/gestion_academica/urls.py)
- [Rutas de empresas](../backend/empresas/urls.py)
- [Rutas de bitacoras y visitas](../backend/bitacoras/urls.py)
