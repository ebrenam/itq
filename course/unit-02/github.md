# Configuración de repositorio GitHub

- URL del repositorio

```text
https://github.com/ebrenam/itq-artifacts.git
```

- Crear nuevo respotirioo desde línea de comando.

```bash
echo "# itq-artifacts" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/ebrenam/itq-artifacts.git
git push -u origin main
```

- Subir un repositorio existente desde línea de comando.

```bash
git remote add origin https://github.com/ebrenam/itq-artifacts.git
git branch -M main
git push -u origin main
```
