# flutter-android-go-builder
  
## 使用方法

  先修改build.sh中的参数，然后执行

```shell
./build.sh
docker push ghcr.io/yangjuncode/flutter-builder:${FLUTTER_VERSION}
```

参数说明：

- `go_version`：go版本，默认为1.21.13
- `flutter_version`：flutter版本，默认为3.24.3
- `build_in_cn`：是否在国内构建，默认为0，即在国外构建


## ghcr.io登录

Authenticating with a personal access token (classic)
GitHub Packages only supports authentication using a personal access token (classic). For more information, see "Managing your personal access tokens."

Create a new personal access token (classic) with the appropriate scopes for the tasks you want to accomplish. If your organization requires SSO, you must enable SSO for your new token.

Note: By default, when you select the write:packages scope for your personal access token (classic) in the user interface, the repo scope will also be selected. The repo scope offers unnecessary and broad access, which we recommend you avoid using for GitHub Actions workflows in particular. For more information, see "Security hardening for GitHub Actions." As a workaround, you can select just the write:packages scope for your personal access token (classic) in the user interface with this url: <https://github.com/settings/tokens/new?scopes=write:packages>.

Select the read:packages scope to download container images and read their metadata.
Select the write:packages scope to download and upload container images and read and write their metadata.
Select the delete:packages scope to delete container images.
For more information, see "Managing your personal access tokens."

Save your personal access token (classic). We recommend saving your token as an environment variable.

export CR_PAT=YOUR_TOKEN
Using the CLI for your container type, sign in to the Container registry service at ghcr.io.

$ echo $CR_PAT | docker login ghcr.io -u USERNAME --password-stdin
> Login Succeeded

## 清理docker build环境

```shell
docker system prune -a
```
