# MDCC Agent Suite para Visual Studio Code

Conjunto de agentes personalizados para consultar, arquitetar, diagnosticar e validar soluções de **Microsoft Dynamics 365 Contact Center** dentro do VS Code.

## O que está incluído

| Agente | Função |
|---|---|
| **MDCC Master** | Orquestra pesquisa, arquitetura, troubleshooting e revisão adversarial. |
| **MDCC Researcher** | Pesquisa todos os `.md` sincronizados e valida no Microsoft Learn. É subagente interno. |
| **MDCC Architect** | Analisa topologias, integrações, segurança, ALM, escala e trade-offs. |
| **MDCC Troubleshooter** | Produz diagnóstico ordenado por evidência e menor risco. |
| **MDCC Validator** | Bloqueia caminhos inventados, confusão de produto e afirmações sem fonte. É subagente interno. |

## Arquitetura de fundamentação

```text
Pergunta no VS Code
        │
        ▼
   MDCC Master
   ├── MDCC Researcher ──► .reference/.../contact-center/**/*.md
   │                         └── Microsoft Learn ao vivo
   ├── MDCC Architect
   ├── MDCC Troubleshooter
   └── MDCC Validator
        │
        ▼
Resposta com evidência, riscos e confiança
```

A documentação não é tratada como treinamento permanente. Ela é clonada e atualizada localmente para ser pesquisada a cada interação. Questões sensíveis a mudanças são verificadas novamente no Microsoft Learn.

## Pré-requisitos

- Visual Studio Code atualizado;
- GitHub Copilot Chat com suporte a agentes;
- Git instalado;
- acesso à internet para GitHub e Microsoft Learn;
- PowerShell no Windows ou Bash + Python 3 em Linux/macOS.

## Instalação

1. Copie todo o conteúdo deste pacote para a raiz do workspace.
2. Abra o workspace no VS Code.
3. Execute `Terminal > Run Task > MDCC: Sync official documentation`.
4. Confirme a criação de:
   - `.reference/dynamics-365-contact-center/contact-center`;
   - `.reference/source-manifest.json`;
   - `.reference/mdcc-doc-index.json`.
5. Abra o Chat do Copilot e selecione **MDCC Master** na lista de agentes.

O VS Code reconhece agentes de workspace em `.github/agents/*.agent.md`.

## Atualização das fontes

Execute novamente a task **MDCC: Sync official documentation**. O script:

- atualiza o branch `main` com `fetch` e `reset`;
- inclui todos os arquivos `.md` abaixo de `contact-center`;
- grava commit, data e quantidade de arquivos;
- gera um índice de títulos e metadados para auditoria.

Execução manual no Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\sync-mdcc-docs.ps1
```

Linux/macOS:

```bash
./scripts/sync-mdcc-docs.sh
```

## Como usar

Exemplos:

```text
Analise por que uma chamada de voz fica muda antes de chegar ao IVR do Copilot Studio.
```

```text
Desenhe uma topologia em que voz chega por operadora/Teams Phone e WhatsApp por ACS. Avalie conflito, licenciamento, segurança e operação.
```

```text
Valide se esta funcionalidade é nativa e mostre exatamente a fonte oficial: notificar supervisor por sentimento negativo.
```

## Limitações deliberadas

- O agente não pode garantir erro zero; ele reduz o risco por validação documental e revisão adversarial.
- O Microsoft Learn pode mudar depois da última sincronização local. Por isso caminhos de interface e disponibilidade devem ser validados ao vivo.
- Algumas páginas do Contact Center reutilizam conteúdo do Dynamics 365 Customer Service. O agente deve avaliar contexto, e não rejeitar automaticamente essas páginas.
- Ferramentas declaradas no frontmatter que não existirem na instalação do VS Code são ignoradas pelo próprio VS Code.

## Fontes configuradas

- Repositório: `MicrosoftDocs/dynamics-365-contact-center`, diretório `contact-center`.
- Microsoft Learn: `https://learn.microsoft.com/en-us/dynamics365/contact-center/`.
- Formato de agentes do VS Code: `.github/agents/*.agent.md`.

## Validação

Use `tests/acceptance-scenarios.md` para testar os agentes contra casos propensos a respostas incorretas ou caminhos administrativos inventados.
