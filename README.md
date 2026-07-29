# Laboratorio 13 — Integración: método GET `/user`

Aplicación iOS en SwiftUI que consume la API REST de GitHub. La tercera pestaña (`Profile`) obtiene **todos los datos del usuario autenticado** mediante:

```http
GET https://api.github.com/user
```

## Cumplimiento del laboratorio

- SwiftUI + MVVM.
- `GitHubUser` como modelo `Decodable`.
- `GitHubAPIService` como capa de red.
- `ProfileViewModel` controla carga, errores y datos de la vista Profile.
- La pestaña número 3 es `Profile`.
- Nombre, login, avatar, bio, repositorios públicos, followers, following, empresa, ubicación, email y URL se obtienen de GitHub.
- Ningún dato personal del perfil está hardcodeado.
- Pull-to-refresh en Profile.
- Manejo de token faltante y errores HTTP.
- Cabeceras modernas de GitHub REST API (`Accept`, `Authorization: Bearer`, `X-GitHub-Api-Version: 2026-03-10`).

## Requisitos

- macOS
- Xcode 16 o superior
- iOS 16+
- Token personal de GitHub

## Configurar `GITHUB_TOKEN`

1. Abre `GitHubClientLab13.xcodeproj`.
2. Ve a **Product > Scheme > Edit Scheme...**
3. Selecciona **Run > Arguments**.
4. En **Environment Variables**, agrega:
   - Name: `GITHUB_TOKEN`
   - Value: tu token de GitHub
5. Marca la casilla para activarlo.
6. Ejecuta con `Cmd + R`.

> No pegues el token dentro de ningún archivo Swift ni lo subas a GitHub.

## Permisos del token

Para `GET /user`, un token válido permite consultar el usuario autenticado. Para listar repositorios privados o crear repositorios desde las otras pestañas, el token debe tener los permisos correspondientes.

## Estructura

```text
GitHubClientLab13/
├── Models/
│   ├── GitHubUser.swift
│   ├── Repository.swift
│   └── CreateRepositoryRequest.swift
├── Services/
│   └── GitHubAPIService.swift
├── ViewModels/
│   ├── ProfileViewModel.swift
│   ├── RepositoriesViewModel.swift
│   └── CreateRepositoryViewModel.swift
├── Views/
│   ├── RootTabView.swift
│   ├── RepositoriesView.swift
│   ├── CreateRepositoryView.swift
│   └── ProfileView.swift
└── GitHubClientLab13App.swift
```

## Evidencia sugerida para entregar

1. Captura de la app con la tercera pestaña Profile seleccionada.
2. Captura del perfil mostrando información real obtenida desde GitHub.
3. Captura de `GitHubAPIService.fetchAuthenticatedUser()` usando `/user`.
4. Captura de `ProfileViewModel`.
5. Captura de `ProfileView` sin datos personales hardcodeados.

