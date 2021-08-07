# Gitpodified Dotfiles Base

> **This is not recommended for regular usage!** Use `gitpodified-dotfiles/full` (5 GB+) instead for all-in-one package. For specific use cases, please see the root README instead.

## Usage

### Required Variables

Configure these variables [in the UI](https://gitpod.io/variables) or through the command line within an workspace (scoped to repository only) with `gp env`.

* `DOTFILES_REPO_URL` - The Git URL of your dotfiles repo, must be public for `setup-dotfiles` script to succeed if ran manually. When ran as part of an prebuild, through placing `GITPOD_WS_PREBUILD=1` in front of an command or doing `|| true` at the back is fine.

### Optional Variables

* `GITPODIFY_LOGCOLLECTOR_*` - Setup Dotfiles script/Gitpodify CLI specific telemetry settings. You may need to enable this to automagically send usage logs to us for debugging and analyitics stuff. Note that you can run `gitpodify telemetry upload` to upload telemetry stuff manually to us.

### On your repository

In your `.gitpod.yml` file, add or change the image key's value into our GHCR image.

```yml
image: ghcr.io/madebythepinshub/gitpodified-dotfiles/base
```

In case you're using an custom Dockerfile, change the base image to `ghcr.io/madebythepinshub/gitpodified-dotfiles/base`.
