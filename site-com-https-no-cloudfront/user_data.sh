#!/bin/bash
# Boot script of the site of the Struct8 tutorial "Site com HTTPS no CloudFront".
# EC2 runs it once, at the instance's first boot. It writes the page below, with the
# instance's own facts, and serves it on port 80. Output: /var/log/cloud-init-output.log
set -u

SITE=/var/www/struct8
mkdir -p "$SITE"

# Instance facts from the metadata service (IMDSv2). A blank answer shows as a dash.
TOKEN=$(curl -s -m 5 -X PUT http://169.254.169.254/latest/api/token \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 300")
meta() { curl -s -m 5 -H "X-aws-ec2-metadata-token: $TOKEN" "http://169.254.169.254/latest/meta-data/$1"; }
INSTANCE_ID=$(meta instance-id); INSTANCE_TYPE=$(meta instance-type)
AZ=$(meta placement/availability-zone); REGION=$(meta placement/region)
BOOTED=$(date -u '+%d/%m/%Y, %H:%M UTC')

cat > "$SITE/index.html" <<'PAGE'
<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Tutoriais do Struct8</title>
<style>
:root{--bg:#0b1023;--fg:#f1f5f9;--mut:#94a3b8;--soft:#cbd5e1;--line:rgba(148,163,184,.18);--card:rgba(255,255,255,.035);--c:#22d3ee;--b:#3b82f6;--p:#8b5cf6;--ok:#34d399;--warn:#fbbf24;--grad:linear-gradient(100deg,var(--c),var(--b) 48%,var(--p))}
*{box-sizing:border-box;margin:0;padding:0}
body{min-height:100vh;color:var(--fg);font:16px/1.55 "Segoe UI",system-ui,-apple-system,Roboto,Arial,sans-serif;-webkit-font-smoothing:antialiased;background:radial-gradient(900px 620px at 8% -12%,rgba(34,211,238,.17),transparent 70%),radial-gradient(1000px 720px at 104% -6%,rgba(139,92,246,.21),transparent 70%),var(--bg)}
main{max-width:1060px;margin:0 auto;padding:56px 20px 36px}
.g{background:var(--grad);-webkit-background-clip:text;background-clip:text;color:transparent}
.top{display:flex;align-items:baseline;gap:12px;font-size:13px;font-weight:600;letter-spacing:.09em;text-transform:uppercase;color:var(--mut)}
.top b{font-size:17px;letter-spacing:.01em;text-transform:none}
.rule{width:120px;height:3px;border-radius:2px;background:var(--grad);margin:18px 0 30px}
h1{font-size:clamp(32px,5.4vw,58px);line-height:1.07;letter-spacing:-.022em;font-weight:750}
.lead{max-width:62ch;margin-top:18px;font-size:18px;color:var(--soft)}
.grid{display:grid;grid-template-columns:1.3fr 1fr;gap:18px;margin-top:40px}
.grid>*{min-width:0}
.card{background:var(--card);border:1px solid var(--line);border-radius:16px;padding:24px}
h2{font-size:12.5px;font-weight:600;letter-spacing:.09em;text-transform:uppercase;color:var(--mut);margin-bottom:16px}
.path{display:flex;align-items:stretch;gap:10px;margin-bottom:18px}
.path .wire{align-self:center}
.hop{flex:1;min-width:0;border:1px solid var(--line);border-radius:12px;padding:11px 12px;background:rgba(11,16,35,.6)}
.hop small{display:block;font-size:12px;color:var(--mut)}
.hop span{font-weight:600}
.hop.on{border-color:rgba(34,211,238,.55);box-shadow:0 0 0 1px rgba(34,211,238,.2),0 0 24px rgba(59,130,246,.18)}
.wire{width:34px;height:2px;flex:none;background:repeating-linear-gradient(90deg,var(--c) 0 6px,transparent 6px 11px);background-size:22px 2px;animation:flow 1s linear infinite}
@keyframes flow{to{background-position:22px 0}}
.badge{display:inline-flex;align-items:center;gap:8px;font-size:13.5px;font-weight:600;border-radius:999px;padding:5px 12px;border:1px solid}
.badge::before{content:"";width:8px;height:8px;border-radius:50%;background:currentColor}
.badge.ok{color:var(--ok);border-color:rgba(52,211,153,.4)}
.badge.warn{color:var(--warn);border-color:rgba(251,191,36,.4)}
.note{color:var(--soft);margin-top:12px}
code{font:14px/1.4 Consolas,"Cascadia Mono",ui-monospace,monospace;color:var(--c);overflow-wrap:anywhere}
dl{display:grid;grid-template-columns:auto 1fr;gap:9px 18px}
dt{color:var(--mut)}
dd{font-weight:600;overflow-wrap:anywhere}
.src{font-size:13px;color:var(--mut);margin-top:16px}
.series{margin-top:18px}
ol{list-style:none;display:grid;grid-template-columns:repeat(3,1fr);gap:12px;counter-reset:t}
li{position:relative;border:1px solid var(--line);border-radius:12px;padding:16px 14px 14px;counter-increment:t}
li::before{content:"0" counter(t);display:block;font-size:24px;font-weight:750;color:rgba(148,163,184,.45);margin-bottom:4px}
li b{display:block;margin-bottom:4px}
li p{font-size:14px;color:var(--soft)}
li.here{border-color:transparent;background:linear-gradient(#13182b,#13182b) padding-box,var(--grad) border-box}
li.here::before{background:var(--grad);-webkit-background-clip:text;background-clip:text;color:transparent}
li em{position:absolute;top:14px;right:12px;font-style:normal;font-size:11.5px;font-weight:600;letter-spacing:.06em;text-transform:uppercase;color:var(--mut)}
li.here em{color:var(--c)}
footer{margin-top:34px;font-size:13px;color:var(--mut)}
@media (max-width:820px){.grid{grid-template-columns:1fr}ol{grid-template-columns:1fr}h1 br{display:none}}
@media (max-width:520px){ol{grid-template-columns:1fr}.path{flex-direction:column;align-items:stretch}.wire{width:2px;height:18px;margin:0 auto;background:repeating-linear-gradient(180deg,var(--c) 0 6px,transparent 6px 11px)}}
@media (prefers-reduced-motion:reduce){.wire{animation:none}}
</style>
</head>
<body>
<main>
  <div class="top"><b class="g">Struct8</b> Tutoriais</div>
  <div class="rule"></div>
  <h1>Esta página roda na instância<br> EC2 <span class="g">do desenho</span>.</h1>
  <p class="lead">O desenho virou código Terraform, o Apply no GitHub Actions criou a instância na conta AWS, e o user data da instância publicou esta página no primeiro boot.</p>

  <div class="grid">
    <section class="card">
      <h2>O caminho até você</h2>
      <div class="path">
        <div class="hop"><small>Origem</small><span>Seu navegador</span></div>
        <div class="wire"></div>
        <div class="hop on"><small id="midKind"></small><span id="midName"></span></div>
        <div class="wire"></div>
        <div class="hop"><small>Porta 80, http</small><span>Instância EC2</span></div>
      </div>
      <span class="badge" id="badge"></span>
      <p class="note" id="note"></p>
      <p class="src">Endereço aberto: <code id="addr"></code></p>
    </section>

    <section class="card">
      <h2>A instância que serviu a página</h2>
      <dl>
        <dt>Instância</dt><dd>{{INSTANCE_ID}}</dd>
        <dt>Tipo</dt><dd>{{INSTANCE_TYPE}}</dd>
        <dt>Zona</dt><dd>{{AZ}}</dd>
        <dt>Região</dt><dd>{{REGION}}</dd>
        <dt>Primeiro boot</dt><dd>{{BOOTED}}</dd>
      </dl>
      <p class="src">Lidos do serviço de metadados da instância quando o user data foi executado.</p>
    </section>
  </div>

  <section class="card series">
    <h2>A série</h2>
    <ol>
      <li><b>Desenhar</b><p>Uma VPC com uma instância EC2, compilada em código Terraform.</p></li>
      <li><b>Aplicar</b><p>O código vai para a conta AWS por GitOps, com Plan e Apply.</p></li>
      <li class="here"><em>Este vídeo</em><b>Mudar e destruir</b><p>Este site, a porta 80 e o CloudFront com https. No fim, o Destroy apaga tudo da conta.</p></li>
    </ol>
  </section>

  <footer>Tutoriais do Struct8. Página publicada pelo user data desta instância.</footer>
</main>
<script>
function show(https, host) {
  var ip = /^\d{1,3}(\.\d{1,3}){3}$/.test(host), $ = function (id) { return document.getElementById(id); };
  $('midKind').textContent = https ? 'https' : 'http';
  $('midName').textContent = https ? 'CloudFront' : (ip ? 'IP público' : 'DNS público');
  $('badge').className = 'badge ' + (https ? 'ok' : 'warn');
  $('badge').textContent = https ? 'Conexão criptografada, certificado do ACM' : 'Conexão sem criptografia';
  $('note').textContent = https
    ? 'Você abriu o nome do site. O CloudFront atende em https e busca a página na instância em http.'
    : 'Você abriu o endereço da instância. A conexão vai direto à máquina, sem certificado.';
  $('addr').textContent = (https ? 'https://' : 'http://') + (host || 'localhost');
}
show(location.protocol === 'https:', location.host);
</script>
</body>
</html>
PAGE

sed -i -e "s|{{INSTANCE_ID}}|${INSTANCE_ID:--}|" -e "s|{{INSTANCE_TYPE}}|${INSTANCE_TYPE:--}|" \
  -e "s|{{AZ}}|${AZ:--}|" -e "s|{{REGION}}|${REGION:--}|" -e "s|{{BOOTED}}|$BOOTED|" "$SITE/index.html"

# The package repositories need internet access. The public address can arrive a few
# seconds after the boot, so wait for it, for up to 5 minutes.
for _ in $(seq 1 60); do
  curl -s -o /dev/null -m 5 https://checkip.amazonaws.com && break
  sleep 5
done

ROOT=""
if command -v dnf >/dev/null 2>&1; then
  dnf install -y nginx && ROOT=/usr/share/nginx/html
elif command -v apt-get >/dev/null 2>&1; then
  apt-get update -y && DEBIAN_FRONTEND=noninteractive apt-get install -y nginx && ROOT=/var/www/html
fi

if [ -n "$ROOT" ]; then
  cp "$SITE/index.html" "$ROOT/index.html"
  systemctl enable nginx
  systemctl restart nginx
else
  # No package could be installed: Python's built-in web server keeps the page up.
  cat > /etc/systemd/system/struct8-site.service <<UNIT
[Unit]
Description=Struct8 tutorial site
After=network-online.target

[Service]
ExecStart=/usr/bin/python3 -m http.server 80 --directory $SITE
Restart=always

[Install]
WantedBy=multi-user.target
UNIT
  systemctl daemon-reload
  systemctl enable --now struct8-site
fi
