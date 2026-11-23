---
theme: seriph
background: https://cover.sli.dev
class: text-center
highlighter: shiki
lineNumbers: true
info: |
  ## Cours 4 — Intégration Continue & Déploiement Continu
  Université de Rennes · IRISA · DiverSE
  Olivier Barais
drawings:
  persist: false
transition: slide-left
title: "Cours 4 — CI/CD"
mdc: true
pdf: true
export: true
comark: true
download: true
---

# Intégration Continue  
# & Déploiement Continu

**DevSecOps 2026** · Cours 4

<div class="pt-8 text-gray-400">
  Olivier Barais — Université de Rennes / IRISA
</div>

---
layout: default
---

# Plan du cours

<div class="grid grid-cols-2 gap-6 mt-6">

<div v-click class="border-2 border-blue-500/40 bg-blue-50 rounded-xl p-5">
  <div class="flex items-center gap-3">
    <div class="text-4xl">🔄</div>
    <div>
      <div class="font-bold text-lg text-blue-700">1. L'intégration continue</div>
      <div class="text-sm text-gray-500 mt-1">Principes, pipeline &amp; maturité CI</div>
    </div>
  </div>
</div>

<div v-click class="border-2 border-green-500/40 bg-green-50 rounded-xl p-5">
  <div class="flex items-center gap-3">
    <div class="text-4xl">🧰</div>
    <div>
      <div class="font-bold text-lg text-green-700">2. Les outils CI</div>
      <div class="text-sm text-gray-500 mt-1">Jenkins, GitHub Actions &amp; panorama</div>
    </div>
  </div>
</div>

<div v-click class="border-2 border-purple-500/40 bg-purple-50 rounded-xl p-5">
  <div class="flex items-center gap-3">
    <div class="text-4xl">🚀</div>
    <div>
      <div class="font-bold text-lg text-purple-700">3. Le déploiement continu</div>
      <div class="text-sm text-gray-500 mt-1">CI vs CD, pipelines &amp; stratégies</div>
    </div>
  </div>
</div>

<div v-click class="border-2 border-red-500/40 bg-red-50 rounded-xl p-5">
  <div class="flex items-center gap-3">
    <div class="text-4xl">🔒</div>
    <div>
      <div class="font-bold text-lg text-red-700">4. Sécuriser le CI/CD</div>
      <div class="text-sm text-gray-500 mt-1">Bots &amp; tokens comme vecteur d'attaque</div>
    </div>
  </div>
</div>

</div>

---
layout: section
---

# 1. L'intégration continue (CI)

---

# Définitions

<div class="grid grid-cols-2 gap-6 mt-4">
<div class="border-l-4 border-blue-500 pl-4">

**Wikipedia**

> « L'intégration continue est un ensemble de pratiques utilisées en génie logiciel consistant à vérifier à chaque modification de code source que le résultat des modifications ne produit pas de régression. »

</div>
<div class="border-l-4 border-green-500 pl-4">

**CruiseControl.NET**

> « Continuous Integration is a software development practice where members of a team integrate their work frequently, usually each person integrates at least daily — leading to multiple integrations per day. Each integration is verified by an automated build (including test) to detect integration errors as quickly as possible. »

</div>
</div>

<div class="mt-6 bg-gray-100 rounded p-3 text-sm">
<strong>En résumé :</strong> CI = fusionner souvent + compiler automatiquement + tester automatiquement + être alerté immédiatement.
</div>

---

# Objectifs de l'intégration continue

<v-clicks>

**1. Maintenir l'équipe en phase**
- Intégrer régulièrement pour éviter les divergences longues
- Détecter les conflits rapidement, quand ils sont encore petits

**2. Limiter les risques et la complexité**
- Chaque intégration est un delta faible → problèmes circonscrits
- Fin de l'"*integration hell*" (semaines de merge en fin de sprint)
**3. Compiler et tester à intervalles réguliers**
- Build reproductible sur un serveur neutre (pas "ça marche chez moi")
- Tests automatiques comme filet de sécurité

**4. Produire une livraison potentielle à chaque instant**
- Le trunk est toujours dans un état déployable
- Accélère le time-to-market

</v-clicks>

<style>
/* style.css */
.slidev-layout.two-cols-header {
  grid-template-columns: 4fr 2fr;
}
li {
  font-size: 0.9em;
  margin-top: 0.5em;
  margin-bottom: 0.5em;
}
</style>

---

# Pourquoi automatiser ?

<div class="grid grid-cols-3 gap-4 mt-6">
<div v-click class="bg-blue-50 rounded-lg p-4 text-center">
  <div class="text-4xl mb-2">⏱️</div>
  <div class="font-bold text-blue-700">Gagner du temps</div>
  <div class="text-sm mt-2">Tâches répétitives exécutées en secondes, pas en heures. Les développeurs se concentrent sur la valeur ajoutée.</div>
</div>
<div v-click class="bg-green-50 rounded-lg p-4 text-center">
  <div class="text-4xl mb-2">✅</div>
  <div class="font-bold text-green-700">Gagner en confiance</div>
  <div class="text-sm mt-2">Chaque commit validé automatiquement. Le feedback est immédiat et objectif. Moins de surprises en production.</div>
</div>
<div v-click class="bg-purple-50 rounded-lg p-4 text-center">
  <div class="text-4xl mb-2">📚</div>
  <div class="font-bold text-purple-700">Réduire la documentation</div>
  <div class="text-sm mt-2">Les scripts de build et les pipelines <em>sont</em> la documentation vivante du processus de livraison.</div>
</div>
</div>

<div v-click class="mt-6 border border-orange-300 bg-orange-50 rounded p-3">
  <strong>Principe clé :</strong> Si une tâche est difficile, la faire plus souvent la rend plus facile — et plus automatique.
  <em>(cf. "If it hurts, do it more often" — Jez Humble)</em>
</div>

---

# Par où commencer ?

<div class="grid grid-cols-2 gap-8 mt-4">
<div>

**Les 4 composants fondamentaux**

<v-clicks>

1. **Gestionnaire de versions (VCS)**  
   Git, SVN — tout le code, toujours versionné

2. **Tests automatisés**  
   JUnit, pytest, Jest… sans tests, pas d'IC réelle

3. **Scripts d'automatisation + ordonnanceur**  
   Make, Maven, npm scripts + crontab / webhook

4. **Outils de communication**  
   Email, Slack, dashboard de CI — le feedback doit être visible

</v-clicks>

</div>
<div class="flex flex-col items-center justify-center gap-4">
  <img src="/junit-logo.png" class="h-12" />
  <div class="text-sm text-gray-500 text-center">Tests automatisés = pierre angulaire de l'IC</div>
  <div class="flex gap-4">
    <div class="text-3xl">🕐</div>
    <div class="text-3xl">📱</div>
    <div class="text-3xl">📧</div>
  </div>
  <div class="text-xs text-gray-400">Ordonnanceur · Notifications · Alertes</div>
</div>
</div>

---

# "Integration Hell" et la règle d'or

> "Continuous Integration is a software development practice where members of a team integrate their work frequently, usually each person integrates **at least daily** — leading to multiple integrations per day."  
> — Martin Fowler (2006)

<div class="grid grid-cols-2 gap-6 mt-4">
<div class="bg-red-50 rounded p-4">
  <strong class="text-red-700">❌ Sans CI — Integration Hell</strong>
  <ul class="text-sm mt-2">
    <li>Branches longues (semaines)</li>
    <li>Conflits massifs au merge</li>
    <li>Bugs découverts tard, coûteux</li>
    <li>Peur de toucher au code</li>
  </ul>
</div>
<div class="bg-green-50 rounded p-4">
  <strong class="text-green-700">✅ Avec CI</strong>
  <ul class="text-sm mt-2">
    <li>Commits petits et fréquents</li>
    <li>Conflits détectés en minutes</li>
    <li>Build cassé = signal immédiat</li>
    <li>Confiance pour refactorer</li>
  </ul>
</div>
</div>

<div class="mt-4 text-center font-bold text-blue-600">
Règle d'or : si le build est cassé, <em>tout s'arrête</em> jusqu'à ce qu'il soit réparé.
</div>

---

# Le pipeline CI : concept

```
  Push / PR
     │
     ▼
  ┌─────────────────────────────────────────────┐
  │              Pipeline CI                    │
  │                                             │
  │  Checkout → Build → Tests → Lint → Rapport │
  └─────────────────────────────────────────────┘
     │            │         │
     │            │         └─► Notification (succès/échec)
     │            └───────────► Artefact (JAR, wheel, image…)
     └────────────────────────► Badge de statut
```

**Un pipeline CI doit être :**
- **Rapide** : feedback en moins de 10 minutes idéalement
- **Reproductible** : même résultat sur n'importe quelle machine
- **Transparent** : logs accessibles, historique visible

---

# Les tests dans le pipeline CI

**Pyramide des tests :**

```
              ▲
             /E2E\       ← Lents, coûteux, peu nombreux
            /─────\
           /  Intég \    ← Test d'intégration (DB, API, service)
          /──────────\
         /  Unitaires \  ← Rapides, nombreux, isolés
        /──────────────\
```

**Dans le pipeline CI :**
```yaml
- name: Tests unitaires
  run: pytest tests/unit/ -v

- name: Tests d'intégration
  run: pytest tests/integration/ -v
  
- name: Couverture de code
  run: pytest --cov=src --cov-report=xml

- name: Upload coverage
  uses: codecov/codecov-action@v4
```

---

# Reporting et observabilité CI

<div class="grid grid-cols-3 gap-3 mt-2">
<div>
  <div class="text-xs text-gray-500 mb-1 text-center">Couverture de code (branch/line)</div>
  <img src="/ci-coverage-viewer.png" class="rounded shadow w-full" />
</div>
<div>
  <div class="text-xs text-gray-500 mb-1 text-center">Métriques build (tests, violations, couverture)</div>
  <img src="/ci-build-metrics.jpg" class="rounded shadow w-full" />
</div>
<div>
  <div class="text-xs text-gray-500 mb-1 text-center">Tests de performance (JMeter / Hudson)</div>
  <img src="/ci-performance-tests.png" class="rounded shadow w-full" />
</div>
</div>

<div class="mt-4 text-sm">

**Ce qu'un bon tableau de bord CI expose :**

- 📊 Tendance des builds (succès/échec dans le temps)
- 🧪 Couverture de code par module (branch coverage, line coverage)
- ⏱️ Temps de build par étape (détecter les ralentissements)
- 🚨 Violations de règles qualité (PMD, Checkstyle, SonarQube)
- 📈 Performance des tests de charge (temps de réponse, % erreurs)

</div>

---

# Le cycle vertueux de l'intégration continue

<div class="flex justify-center mt-2">
  <img src="/ci-cycle-vertueux.png" class="rounded shadow" style="max-height: 380px;" />
</div>

<div class="text-xs text-gray-500 text-center mt-2">
  5 niveaux de maturité CI : de la compilation manuelle au monitoring en continu
</div>

---

# Les 5 niveaux de maturité CI

<div class="grid grid-cols-5 gap-2 mt-4 text-xs">
<div v-click class="bg-blue-50 rounded p-2 text-center">
  <div class="font-bold text-blue-700 mb-1">① Compilation manuelle</div>
  <div class="text-gray-500">À la demande</div>
  <div class="mt-2 font-mono bg-white rounded p-1">compile<br/>+ test</div>
</div>
<div v-click class="bg-green-50 rounded p-2 text-center">
  <div class="font-bold text-green-700 mb-1">② Build planifié</div>
  <div class="text-gray-500">Par heure</div>
  <div class="mt-2 font-mono bg-white rounded p-1">checkout<br/>+ compile<br/>+ test<br/>+ email</div>
</div>
<div v-click class="bg-yellow-50 rounded p-2 text-center">
  <div class="font-bold text-yellow-700 mb-1">③ Releases bouton</div>
  <div class="text-gray-500">Hebdomadaire</div>
  <div class="mt-2 font-mono bg-white rounded p-1">branche<br/>+ test<br/>+ package<br/>+ release</div>
</div>
<div v-click class="bg-orange-50 rounded p-2 text-center">
  <div class="font-bold text-orange-700 mb-1">④ Déploiement</div>
  <div class="text-gray-500">Par mois</div>
  <div class="mt-2 font-mono bg-white rounded p-1">livraison<br/>+ MAJ auto<br/>+ install<br/>+ test</div>
</div>
<div v-click class="bg-red-50 rounded p-2 text-center">
  <div class="font-bold text-red-700 mb-1">⑤ Monitoring</div>
  <div class="text-gray-500">En continu</div>
  <div class="mt-2 font-mono bg-white rounded p-1">alertes<br/>+ logs<br/>+ RSS<br/>+ dashboard</div>
</div>
</div>

<div v-click class="mt-4 text-center text-sm text-gray-600">
  Chaque niveau apporte plus de confiance et réduit le risque par rapport au précédent.
</div>

---

# Cas d'usage : un commit déclenche tout

<div class="text-sm mt-2">

```
                    commit
  Développeur  ──────────────►  SCM (Git)
                                    │
                              webhook / polling
                                    │
                                    ▼
                         Serveur CI (Jenkins/GitHub Actions)
                                    │
                   ┌────────────────┼────────────────┐
                   ▼                ▼                 ▼
              Compilation       Tests JUnit      Inspection code
              (Maven/npm)       (succès ✓)       (PMD, SonarQube)
                   │                │                 │
                   └────────────────┴─────────────────┘
                                    │
                            ┌───────┴───────┐
                            ▼               ▼
                     Déploiement      Notification
                     (recette)        (email, Slack)
```

</div>

<div class="mt-2 grid grid-cols-3 gap-2 text-xs">
<div v-click class="bg-blue-50 p-2 rounded">📤 <strong>Push</strong> : Le dev commit et push sur la branche</div>
<div v-click class="bg-green-50 p-2 rounded">⚙️ <strong>Build</strong> : CI compile, teste, inspecte automatiquement</div>
<div v-click class="bg-purple-50 p-2 rounded">📣 <strong>Feedback</strong> : Résultat en quelques minutes (succès ou échec)</div>
</div>

---
layout: section
---

# 2. Outils d'intégration continue

---

# Jenkins / Hudson : l'histoire

<div class="grid grid-cols-2 gap-6 mt-2">
<div>

**Chronologie**

- **2004** — Hudson créé par Kohsuke Kawaguchi chez Sun Microsystems
- **2010** — Oracle rachète Sun, tensions sur la gouvernance
- **2011** — Fork communautaire → **Jenkins** (Linux Foundation)
- Aujourd'hui Jenkins est le standard de facto *on-premise*

**Pourquoi Jenkins a dominé une décennie ?**
- Open source, extensible (1 800+ plugins)
- Pipeline-as-code avec le `Jenkinsfile`
- Master/agent pour distribuer les builds
- Intégration avec tous les outils du marché

</div>
<div class="flex flex-col items-center justify-center gap-4">
  <img src="/jenkins-logo.png" class="h-28" />
  <div class="text-xs text-gray-500 text-center">Jenkins — le serveur CI le plus déployé</div>
</div>
</div>

<style>
/* style.css */
.slidev-layout.two-cols-header {
  grid-template-columns: 4fr 2fr;
}
li {
  font-size: 0.9em;
  margin-top: 0em;
  margin-bottom: 0em;
}
</style>


---
zoom: 0.85
---

# Pipeline Jenkins (Jenkinsfile)

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps { checkout scm }
        }
        stage('Build') {
            steps { sh 'mvn clean package -DskipTests' }
        }
        stage('Test') {
            steps { sh 'mvn test' }
            post {
                always { junit 'target/surefire-reports/*.xml' }
            }
        }
        stage('Code Quality') {
            steps { sh 'mvn sonar:sonar' }
        }
        stage('Deploy to Staging') {
            when { branch 'main' }
            steps { sh './deploy.sh staging' }
        }
    }
    post {
        failure { mail to: 'team@example.com', subject: 'Build failed' }
    }
}
```

---

# Panorama des outils CI modernes

| Outil | Modèle | Points forts | Cas d'usage |
|-------|--------|-------------|-------------|
| **GitHub Actions** | SaaS / on-prem | Intégré à GitHub, marketplace d'actions | Projets GitHub |
| **GitLab CI** | SaaS / on-prem | Intégré à GitLab, Auto DevOps | Projets GitLab |
| **Jenkins** | On-prem | Très configurable, 1800+ plugins | Enterprise legacy |
| **CircleCI** | SaaS | Rapide, bonne DX | Startups |
| **Travis CI** | SaaS | Simple, historique OSS | OSS (en déclin) |
| **Tekton** | Kubernetes-native | Cloud-native, flexible | Kubernetes |
| **ArgoCD** | Kubernetes GitOps | CD déclaratif | GitOps |

<div class="mt-3 text-sm text-gray-600">
La tendance : <strong>YAML-first</strong>, intégration native à la forge Git, runners éphémères (conteneurs).
</div>

---
zoom: 0.9
---

# GitHub Actions : introduction

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Set up Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.12'
      
      - name: Install dependencies
        run: pip install -r requirements.txt
      
      - name: Run tests
        run: pytest --tb=short
```

---

# GitHub Actions : concepts clés

| Concept | Description |
|---------|-------------|
| **Workflow** | Automatisation définie dans un fichier YAML |
| **Event** | Déclencheur (`push`, `pull_request`, `schedule`, `workflow_dispatch`…) |
| **Job** | Ensemble d'étapes s'exécutant sur un runner |
| **Step** | Commande ou action individuelle |
| **Action** | Bloc réutilisable (marketplace GitHub) |
| **Runner** | Machine qui exécute le job (GitHub-hosted ou self-hosted) |
| **Artifact** | Fichier produit par le workflow (JAR, rapport, image…) |

---
layout: section
---

# 3. Le déploiement continu (CD)

---

# CI vs CD : les nuances

| Acronyme | Signification | Description |
|----------|--------------|-------------|
| **CI** | Continuous Integration | Build + test automatiques à chaque commit |
| **CD** | Continuous Delivery | Artifact toujours prêt à être déployé en production |
| **CD** | Continuous Deployment | Déploiement automatique en production si les tests passent |

```
  Commit → CI (build+test) → Artifact → [approbation manuelle] → Production
                                               ↑
                              Continuous Delivery s'arrête ici
                              Continuous Deployment l'automatise
```

> En DevSecOps, on ajoute des "security gates" entre chaque étape.

---
zoom: 0.9
---

# Pipeline CD complet

```yaml
jobs:
  build:
    # ... (voir CI)
    
  security-scan:
    needs: build
    steps:
      - name: Scan SAST
        uses: github/codeql-action/analyze@v3
      - name: Scan dépendances
        run: pip-audit

  build-image:
    needs: security-scan
    steps:
      - name: Build Docker image
        run: docker build -t app:${{ github.sha }} .
      - name: Scan image
        uses: aquasecurity/trivy-action@master
      - name: Push vers registre
        run: docker push ghcr.io/org/app:${{ github.sha }}

  deploy-staging:
    needs: build-image
    environment: staging
    # ...
```

---

# Stratégies de déploiement

| Stratégie | Description | Risque | Rollback |
|-----------|-------------|--------|----------|
| **Recreate** | Stop v1, start v2 | Downtime | Lent |
| **Rolling update** | Remplace progressivement les instances | Faible | Automatique |
| **Blue/Green** | Deux environnements, bascule du traffic | Nul | Instantané |
| **Canary** | 1-5% du traffic vers v2 en premier | Très faible | Instantané |
| **Feature flags** | Déploiement découplé de l'activation | Nul | Par flag |

---
layout: section
---

# 4. Les bots CI/CD comme vecteur d'attaque

---

# La confiance accordée aux tokens CI/CD

**Un pipeline CI/CD a typiquement accès à :**

```yaml
env:
  DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
  AWS_ACCESS_KEY: ${{ secrets.AWS_ACCESS_KEY }}
  NPM_TOKEN: ${{ secrets.NPM_TOKEN }}
  GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
  KUBECONFIG: ${{ secrets.KUBECONFIG }}
  SIGNING_KEY: ${{ secrets.CODE_SIGNING_KEY }}
```

**Si le pipeline est compromis, l'attaquant peut :**
- Publier des paquets malveillants sur npm/PyPI sous votre nom
- Pousser des images Docker malveillantes
- Accéder à votre infrastructure cloud
- Exfiltrer des secrets

> **SolarWinds** : le build system compromis a permis d'injecter une backdoor dans 18 000 clients.

---
zoom: 0.9
---

# Bonnes pratiques de sécurité CI/CD

**Principe de moindre privilège :**
```yaml
permissions:
  contents: read       # Lire le code seulement
  packages: write      # Écrire des packages si nécessaire
  security-events: write  # Pour les scans de sécurité
  # Tout le reste : non accordé par défaut
```

**Épingler les actions par hash :**
```yaml
# ❌ Dangereux : la tag peut être déplacée
uses: actions/checkout@v4

# ✅ Sûr : hash immuable
uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683
```

**Autres recommandations :**
- Utiliser des runners éphémères (pas de self-hosted persistant)
- Rotation régulière des secrets
- Audit des logs CI/CD
- Branch protection rules (require PR, require status checks)

---
layout: center
class: text-center
---

# À retenir

> Le pipeline CI/CD est **la colonne vertébrale de votre supply chain**.  
> C'est aussi l'une des cibles les plus attrayantes pour un attaquant :  
> compromettre le build, c'est compromettre **tous vos utilisateurs**.

<div class="mt-6 grid grid-cols-4 gap-4 text-sm">
<div class="bg-blue-50 rounded p-2">🔄 Intégrer<br/><strong>souvent</strong></div>
<div class="bg-green-50 rounded p-2">⚡ Automatiser<br/><strong>tout</strong></div>
<div class="bg-yellow-50 rounded p-2">📊 Mesurer<br/><strong>constamment</strong></div>
<div class="bg-red-50 rounded p-2">🔒 Sécuriser<br/><strong>chaque étape</strong></div>
</div>

---
layout: default
---

# Merci

<div class="mt-8 max-w-2xl mx-auto text-left">

**Ressources :**

- 📄 **Poly du cours** : [télécharger le poly (PDF)](https://raw.githubusercontent.com/barais/devsecops.module4/refs/heads/master/poly/poly.pdf)
* [GitHub Actions docs](https://docs.github.com/en/actions)
* [Martin Fowler — Continuous Integration](https://martinfowler.com/articles/continuousIntegration.html)
* [Jenkins — Pipeline documentation](https://www.jenkins.io/doc/book/pipeline/)
- ➡️ **Cours suivant — Cours 5 — Conteneurs logiciels** : [https://olivier.barais.fr/devsecops.module5](https://olivier.barais.fr/devsecops.module5)

</div>

<div class="mt-8 text-sm opacity-50">
Olivier Barais · Module DevSecOps
</div>