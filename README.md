
# backend
### Crear .env ejemplo variable de entorno
```
* Ruby version 3.3.4
```
### Crear .env ejemplo variable de entorno
```
FRONT_END=http://localhost:8080
```
## Correr comandos
```
bundle install
```
```
rails db:migrate
```
```
rails db:seed
```
```
rails test:db
```
## Correr servidor
```
rails server
```

## Detalles del Backend (Ruby on Rails)

### Creación de Usuarios y Horarios

En Rails, los usuarios y horarios se crean a través de seeders. Estos seeders inicializan la base de datos con datos de ejemplo para facilitar las pruebas y el desarrollo.

### Testing

Se testearon varios casos de uso para asegurar la buena funcionalidad de los controladores y modelos. Las pruebas incluyen:

- Validaciones de los modelos.
- Funcionalidad de los controladores.

### Algoritmo de Asignación de Horarios

El algoritmo principal que se utilizó para resolver el problema de asignación de horarios es un algoritmo voraz (greedy). La lógica del algoritmo es la siguiente:

1. **Selección Directa**: Si un usuario selecciona todas las horas de un día y el resto de los usuarios no, inmediatamente se le asignan las horas a ese usuario.
2. **Iteración**: Se itera por los usuarios que tengan el menor número de horas asignadas, asignando horas hasta que no queden más días disponibles.

El algoritmo garantiza que las horas se asignen de manera eficiente y equitativa, priorizando siempre a los usuarios con menos horas asignadas para asegurar una distribución justa.

### Implementación del Algoritmo

El algoritmo de asignación de horarios está implementado en el servicio `GreedyService` y es invocado desde el controlador cuando un usuario selecciona los días y hace clic en el botón "Actualizar".


