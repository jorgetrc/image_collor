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

## Como Executar Localmente

Se você deseja rodar a última versão gerada pela esteira:

```bash
# Substitua <seu-usuario> pelo seu nome no Docker Hub
docker pull <seu-usuario>/image-collor:latest
docker run -d -p 80:80 --name web-collor <seu-usuario>/image-collor:latest