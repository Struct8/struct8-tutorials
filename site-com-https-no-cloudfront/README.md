# Site com HTTPS no CloudFront: o script de boot da instância EC2

Esta pasta guarda o script de boot do vídeo "Site com HTTPS no CloudFront, do Apply ao Destroy,
no Struct8", da série Tutoriais do Struct8. O script publica um site na instância EC2 do desenho.

## Como o desenho usa esta pasta

No diagrama do Struct8, o componente GitHub aponta para este repositório, e a instância EC2
ligada a ele usa o script como user data. O campo User Data File Path da instância recebe
`site-com-https-no-cloudfront/user_data.sh`, e o Apply cria a instância com ele.

## O que o script faz

- Lê do serviço de metadados da instância (IMDSv2) o ID, o tipo, a zona e a região.
- Escreve a página do site com esses dados.
- Instala o nginx e publica a página na porta 80. Se nenhum pacote puder ser instalado, o
  servidor web do Python publica a página.

**Importante:** o EC2 executa o user data só no primeiro boot. Para que uma mudança no script
chegue à máquina, a instância precisa ser substituída: ligue User Data Replace On Change no
formulário da instância.

O registro da execução fica em `/var/log/cloud-init-output.log`, na instância.
