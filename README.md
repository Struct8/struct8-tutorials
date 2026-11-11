# Tutoriais do Struct8

Este repositório guarda os arquivos que os vídeos da série Tutoriais do Struct8 leem do GitHub,
como o script de boot de uma instância EC2. Cada vídeo que usa um arquivo daqui tem uma pasta
própria, com o nome do vídeo.

| Pasta | Vídeo | O que a pasta guarda |
|---|---|---|
| [`site-com-https-no-cloudfront`](site-com-https-no-cloudfront/) | Site com HTTPS no CloudFront, do Apply ao Destroy, no Struct8 | O script de boot que publica um site na instância EC2 |

## Como um desenho usa este repositório

No diagrama do Struct8, o componente GitHub aponta para este repositório, e o recurso ligado a
ele lê o arquivo pelo caminho a partir da raiz. Por exemplo, o campo User Data File Path da
instância recebe `site-com-https-no-cloudfront/user_data.sh`.
