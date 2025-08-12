# Guía de Contribución

¡Gracias por tu interés en contribuir a este proyecto! Esta guía te ayudará a entender cómo puedes participar.

## 🤝 Cómo Contribuir

### Reportar Bugs
1. Verifica que el bug no haya sido reportado anteriormente
2. Crea un issue con la plantilla de bug report
3. Incluye información detallada:
   - Pasos para reproducir
   - Comportamiento esperado vs actual
   - Versiones de herramientas (Terraform, AWS CLI)
   - Logs relevantes

### Sugerir Mejoras
1. Crea un issue con la plantilla de feature request
2. Describe claramente la funcionalidad propuesta
3. Explica por qué sería útil para el proyecto
4. Proporciona ejemplos de uso si es posible

### Contribuir Código

#### Configuración del Entorno de Desarrollo
```bash
# 1. Fork y clonar el repositorio
git clone https://github.com/tu-usuario/serverless-aws-project.git
cd serverless-aws-project

# 2. Crear rama para tu feature
git checkout -b feature/mi-nueva-funcionalidad

# 3. Configurar pre-commit hooks (opcional pero recomendado)
pip install pre-commit
pre-commit install
```

#### Estándares de Código

**Terraform:**
- Usar `terraform fmt` para formatear código
- Documentar variables con descriptions
- Usar nombres descriptivos para recursos
- Seguir convenciones de naming: `proyecto-ambiente-recurso`

**Python:**
- Seguir PEP 8
- Usar type hints cuando sea posible
- Documentar funciones con docstrings
- Logs estructurados en formato JSON

**Commits:**
- Usar conventional commits: `feat:`, `fix:`, `docs:`, etc.
- Mensajes en español o inglés (consistente con el proyecto)
- Un commit por cambio lógico

#### Proceso de Pull Request
1. Asegúrate de que tu código pase todas las pruebas
2. Actualiza la documentación si es necesario
3. Crea el PR con descripción clara de los cambios
4. Responde a los comentarios de revisión
5. Mantén tu rama actualizada con main

### Pruebas
```bash
# Validar Terraform
cd infrastructure
terraform fmt -check
terraform validate

# Probar despliegue (en ambiente de desarrollo)
./scripts/deploy.sh

# Ejecutar pruebas de API
./scripts/test-api.sh
```

## 📋 Checklist para PRs

- [ ] El código sigue los estándares del proyecto
- [ ] Se han añadido pruebas para nuevas funcionalidades
- [ ] La documentación ha sido actualizada
- [ ] Los commits siguen conventional commits
- [ ] El PR tiene una descripción clara
- [ ] Se han probado los cambios localmente

## 🏷️ Etiquetas de Issues

- `bug`: Algo no funciona correctamente
- `enhancement`: Nueva funcionalidad o mejora
- `documentation`: Mejoras en documentación
- `good first issue`: Bueno para nuevos contribuidores
- `help wanted`: Se necesita ayuda de la comunidad
- `question`: Pregunta sobre el proyecto

## 📞 Comunicación

- **Issues**: Para bugs y feature requests
- **Discussions**: Para preguntas generales y discusiones
- **Email**: Para temas sensibles o privados

## 🎯 Áreas de Contribución

### Prioridad Alta
- Mejoras en seguridad
- Optimizaciones de performance
- Documentación y ejemplos
- Pruebas automatizadas

### Prioridad Media
- Nuevas funcionalidades
- Integración con otros servicios AWS
- Herramientas de desarrollo
- Plantillas para diferentes casos de uso

### Prioridad Baja
- Refactoring de código
- Mejoras en UI/UX de scripts
- Optimizaciones menores

## 🚀 Ideas para Contribuir

### Para Principiantes
- Mejorar documentación
- Añadir ejemplos de uso
- Corregir typos
- Mejorar mensajes de error

### Para Desarrolladores Experimentados
- Implementar CI/CD pipeline
- Añadir soporte multi-región
- Implementar blue-green deployments
- Añadir métricas personalizadas

### Para Expertos en AWS
- Optimizaciones de costos
- Mejores prácticas de seguridad
- Patrones de arquitectura avanzados
- Integración con servicios enterprise

## 📚 Recursos Útiles

- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Semantic Versioning](https://semver.org/)

## 🙏 Reconocimientos

Todos los contribuidores serán reconocidos en el README del proyecto. ¡Gracias por hacer este proyecto mejor!