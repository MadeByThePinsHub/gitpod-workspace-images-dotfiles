# Gitpod Custom Workspaces for The Pins Team

This is where our custom Docker images for Gitpod workspaces with dotfiles support, are being developed here.

## Usage

### Basic

1. Before using our images, configure the following variables in [your Gitpod settings](https://gitpod.io/variables):

  - `DOTFILES_REPO_URL` - Git URL of your dotfiles, must be public or with Basic Auth stuff included if needed.
  - Depending on your bootstrap/setup script, you should set variables manually, especially for cloning your seperate private repo full of GPG keys and stuff.
  - It's recommended that any installation stuff in your setup script should be included in your own image in your dotfiles repo. If you prefer not to do that, you need to rerun your script every time your workspace starts.

2. Choose the image you want to use below, then either copy the image repo or its init script.

| GHCR Image Repository | Description | Docs | Init script |
| --- | --- | --- | --- |
| `ghcr.io/madebythepinshub/gitpodified-dotfiles/base` | The base image we use to build `gitpodified-dotfiles/main` image | [README](docker/base/README.md) | `yo gitpodified-dotfiles-main` or `gitpodify init --image ghcr.io/madebythepinshub/gitpodified-dotfiles/base` |

3. If you use the init scripts, either install our Yeoman template with `npm i -g yo @gitpodify/dotfiles-<name-here>` or the Gitpodify CLI with `npm i -g @gitpodify/cli`. Run either these init script listed above based on the image you chose eariler.

4. Got either `.gitpod.yml`, `.gitpod.Dockerfile` or both? If you just state the image name in your Gitpod configuration file, just set the `image` key to either one of them. If you're using an custom Dockerfile, just change the base image.

5. Now push to an temporary branch so you can test things up. If everything works, update the documentation on using Gitpod and merge it.

### Advanced

Have an custom Docker image that uses `gitpod/workspace-base` as your base image and want to use ours? No problem! You can switch wiithin minutes into ours, without breaking anything.

1. Change the base image to `ghcr.io/madebythepinshub/gitpodified-dotfiles/base`. Docker stuff are preinstalled by default, so you can comment them out if needed.

2. Push changes into your repository OR run Docker builds and push the resulting image into your container registry of choice.

3. Open your repo in Gitpod as an fresh workspace to test things up. Make sure to update development docs regarding these changes!

## Differences with the official Gitpod workspace images

| Type | `gitpod/workspace-full` | `ghcr.io/madebythepinshub/gitpodified-dotfiles/main` |
| --- | --- | --- |
| Base image for `workspace-base` (`gitpodified-dotfiles/base` in our case) | [buildpack-deps:focal][dockerhub-focal] | [buildpack-deps:focal][dockerhub-focal] |
| Main registry | [Docker Hub](https://hub.docker.com) | [GitHub Container Registry (GHCR)](https://ghcr.io) |
| Does includes Docker on base image (NOT the `buildpack-deps:focal` stuff)? | No | Yes |
| Size | TBA | TBA  

[dockerhub-focal]: https://hub.docker.com/_/buildpack-deps?tab=tags&page=1&ordering=last_updated&name=focal
