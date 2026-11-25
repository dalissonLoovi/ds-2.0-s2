# loovi_tokens — tokens do Design System Loovi S2 para Flutter

Cores, espaçamentos, raios, bordas, tipografia (Poppins incluída) e tema
(`LooviTheme.light()`), gerados a partir do seed do DS. Modo de produto padrão: `app-cliente`.

Normalmente você **não precisa** declarar este pacote: ele vem junto com o `loovi_ds`
(veja [`../flutter_ds/README.md`](../flutter_ds/README.md)). Declare-o só se quiser
usar os tokens sem os componentes:

```yaml
loovi_tokens:
  git:
    url: https://github.com/dalissonLoovi/ds-2.0-s2
    path: packages/flutter_tokens
    ref: flutter-v0.1.2
```

Arquivos em `lib/src/generated/` são gerados por `npm run flutter:tokens` — não editar à mão.
