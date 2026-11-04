### Descripción breve del tema técnico y fundamentos de aplicación

- **Tema técnico:** Seguridad: manejo de permisos a nivel de usuarios y roles en SQL Server.

- **Descripción breve:** La seguridad en una base de datos permite controlar qué información puede consultar cada usuario y qué operaciones puede realizar. SQL Server permite asignar permisos directamente a los usuarios o mediante roles que agrupan permisos según sus tareas. Esto ayuda a proteger la información y evitar modificaciones accidentales o no autorizadas.

- **Fundamento de aplicación en Punto Digital:** En nuestro caso de estudio, los usuarios necesitan distintos accesos según las tareas que realizan. Por ejemplo, un usuario encargado de consultar el catálogo puede tener permiso de lectura sobre `producto`, sin poder modificar precios ni stock. Para registrar ventas, se puede autorizar la ejecución de un procedimiento almacenado sin permitir inserciones directas en `registro_venta`. Además, el acceso a los datos personales de `cliente` puede restringirse a quienes lo necesiten. De esta manera, cada usuario cuenta únicamente con los permisos necesarios y los roles facilitan la administración de esos accesos.

- ### Scripts SQL de implementación y pruebas

Los archivos del tema Seguridad se encuentran en la carpeta [`sql/tecnico/seguridad`](../sql/tecnico/seguridad/):

- [`00_ddl_original.sql`](../sql/tecnico/seguridad/00_ddl_original.sql): contiene la creación de las cinco tablas del proyecto. Se utiliza únicamente si se prepara una base de prueba vacía.
- [`01_implementacion.sql`](../sql/tecnico/seguridad/01_implementacion.sql): crea los usuarios, roles y permisos, junto con el procedimiento autorizado para registrar ventas.
- [`02_pruebas.sql`](../sql/tecnico/seguridad/02_pruebas.sql): permite comprobar las operaciones autorizadas y denegadas para los distintos usuarios.
- [`03_logins_opcional.sql`](../sql/tecnico/seguridad/03_logins_opcional.sql): incluye una plantilla opcional para asociar cuentas reales de Windows con usuarios y roles.

### Demostración de utilización

La demostración compara el acceso de usuarios con distintos permisos. Se espera que un usuario con el rol de consulta pueda leer la tabla `producto`, mientras que otro sin ese permiso reciba un rechazo. También se compara la inserción directa en `registro_venta` con la ejecución del procedimiento autorizado: el usuario limitado no puede insertar directamente, pero sí registrar una venta mediante el procedimiento.

El script de pruebas incluye verificaciones de cantidad, método de pago y disponibilidad de stock. Los resultados obtenidos se incorporarán después de ejecutar las pruebas en SQL Server.
