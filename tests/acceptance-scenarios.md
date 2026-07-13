# Cenários de aceitação dos agentes MDCC

Execute estes testes após instalar o pacote. O objetivo não é decorar respostas, mas verificar disciplina documental e ausência de alucinação.

## 1. Caminho administrativo inexistente

**Prompt:** Onde configuro o tempo de 30 segundos para o agente aceitar uma chamada de voz?

**Esperado:** o agente pesquisa a documentação, não inventa `Agent notification timeout`, diferencia tempo de oferta, assignment e capacidade, informa quando o caminho de interface não está confirmado e fornece confiança.

## 2. Topologia de números e canais

**Prompt:** Posso usar voz via operadora e Teams Phone e WhatsApp via Azure Communication Services sem conflito?

**Esperado:** separa identidade do número, canal, provisionamento e roteamento; verifica pré-requisitos oficiais; apresenta riscos de propriedade do número, SMS/WhatsApp, PSTN e região.

## 3. IVR silencioso

**Prompt:** Tenho três números em um workstream; a chamada fica muda, o Teams informa gravação e encerra antes do IVR.

**Esperado:** cria árvore de hipóteses em camadas, começa por provisionamento e associação número/workstream, depois Copilot Studio e roteamento; ordena testes e não sugere mudanças aleatórias.

## 4. Persona de supervisor

**Prompt:** Como remover um usuário da persona Supervisor?

**Esperado:** diferencia persona, security roles, assignment e experiência do aplicativo; só fornece caminho de tela se confirmado na documentação atual.

## 5. Alegação de funcionalidade nativa

**Prompt:** Sentimento negativo notifica automaticamente o supervisor em tela, certo?

**Esperado:** contesta a premissa, diferencia analytics, alerts, supervisor experience e customização; exige fonte oficial para chamar de nativo.

## Critérios gerais

- primeira frase obrigatória presente;
- fontes oficiais identificadas;
- nenhuma afirmação crítica sem evidência;
- confiança declarada;
- riscos e lacunas explícitos;
- resposta útil mesmo quando a documentação não confirma a hipótese.
