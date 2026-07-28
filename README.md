#  Image Color Stack - CI/CD Automático

Este projeto é uma stack de testes que demonstra um fluxo completo de CI/CD utilizando **GitHub Actions**, **Docker Hub** e **Nginx**. A cada alteração de cor no código, uma nova versão da imagem Docker é gerada e tagueada automaticamente.

## Tecnologias Utilizadas

* **Engine:** Nginx (Alpine Linux)
* **CI/CD:** GitHub Actions
* **Registry:** Docker Hub
* **Automação:** GitHub Tag Action (SemVer)

## Como Funciona o Fluxo

1.  **Alteração:** Você altera a cor de fundo ou o conteúdo no arquivo `index.html`.
2.  **Push:** Você faz um `git push` para a branch `main`.
3.  **Tag Automática:** O GitHub Actions calcula a próxima versão (ex: `v1.0.4 -> v1.0.5`).
4.  **Injeção de Versão:** O workflow substitui a string `{{VERSION}}` no HTML pela nova tag gerada.
5.  **Build & Push:** Uma nova imagem Docker é construída e enviada para o Docker Hub com as tags `latest` e a versão específica.

## Configuração Necessária

Para que o workflow funcione, adicione os seguintes **Secrets** em seu repositório (Settings > Secrets and variables > Actions):

| Secret | Descrição |
| :--- | :--- |
| `DOCKERHUB_USERNAME` | Seu nome de usuário no Docker Hub. |
| `DOCKERHUB_TOKEN` | Access Token gerado no painel do Docker Hub. |
| `PAT_TOKEN` | Personal Access Token do GitHub, usado pelo job para clonar e dar push no repositório [`k8s-workflow`](https://github.com/jorgetrc/k8s-workflow) (atualização de `base/kustomization.yml` a cada release). |

### Verificando ou criando o `PAT_TOKEN`

O `GITHUB_TOKEN` padrão das Actions só tem acesso ao próprio repositório, por isso o job usa um PAT para escrever no `k8s-workflow`. Se a pipeline falhar no passo *"Update Kubernetes manifests in k8s-workflow repo"* com o erro:

```
remote: Invalid username or token. Password authentication is not supported for Git operations.
fatal: Authentication failed for 'https://github.com/jorgetrc/k8s-workflow.git/'
```

é sinal de que o `PAT_TOKEN` está ausente, expirado ou revogado. Para verificar/recriar:

1. Acesse **GitHub → seu avatar → Settings → Developer settings → Personal access tokens**.
2. Confira se o token usado no secret ainda existe e não está expirado (tokens classic geralmente têm validade de 30/60/90 dias; fine-grained podem ter até 1 ano).
3. Caso não exista ou esteja expirado, gere um novo:
   - **Classic**: escopo `repo` (acesso completo a repositórios privados/públicos).
   - **Fine-grained** (recomendado): acesso restrito ao repositório `k8s-workflow`, com permissão `Contents: Read and write`.
4. Em `image_collor` → **Settings → Secrets and variables → Actions**, edite (ou crie) o secret `PAT_TOKEN` com o valor do novo token.
5. Re-execute o job que falhou para confirmar que a autenticação funciona.

## Como Executar Localmente

Se você deseja rodar a última versão gerada pela esteira:

```bash
# Substitua <seu-usuario> pelo seu nome no Docker Hub
docker pull <seu-usuario>/image-collor:latest
docker run -d -p 80:80 --name web-collor <seu-usuario>/image-collor:latest