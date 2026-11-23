# CLAUDE.md — Design System S2 (produto)

Regras comuns e contexto de negócio: `../CLAUDE.md` e `../context/`.
Regras de trabalho deste repo (fonte principal): @AGENTS.md

## Papel deste produto
Fonte única de tokens e componentes para **todos** os produtos Loovi. Mudança aqui = mudança potencial em todos os consumidores, por isso sempre **auditar → reportar → aguardar “aplicar”**, com análise de impacto por consumidor.

## Consumidores
| Produto | Pasta | Consome | Observação |
|---|---|---|---|
| Site Loovi | `../site` | `@ds/tokens` (CSS) + `@ds/react` | tema `site-loovi` ainda não consolidado (ver `HANDOFF-CLAUDE-SITE.md`, só local, fora do Git) |
| App do Cliente (Flutter) | `../app-cliente` | `dist/tokens.json` → pacote Dart (proposta, ADR-001 do app) | ícones Hugeicons + aliases |
| Escritório Virtual | fora deste workspace | `@ds/react` | ícones Tabler |

Propostas vindas dos produtos chegam pelo backlog deles. Avaliar aqui e registrar em `DS-BACKLOG-PROXIMAS-ETAPAS.md` só depois de aprovado.
