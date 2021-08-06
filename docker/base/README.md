# Gitpodified Dotfiles Base

> **This is not recommended for regular usage!** Use `gitpodified-dotfiles/full` (5 GB+) instead for all-in-one package or `gitpodified-dotfiles/lang-<lang-slug>` for language-specific stuff.

## Usage

### On your repository

In your `.gitpod.yml` file, add or change the image key's value into our GHCR image.

```yml
image: ghcr.io/madebythepinshub/gitpodified-dotfiles/base
```

In case you're using an custom Dockerfile, change the base image to `ghcr.io/madebythepinshub/gitpodified-dotfiles/base`.
