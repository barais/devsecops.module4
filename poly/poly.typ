// ============================================================
// Polycopié — Cours 4 : Intégration Continue & Déploiement Continu
// Université de Rennes · IRISA / DiverSE
// Olivier Barais
// ============================================================

#set document(
  title: "Cours 4 — Intégration Continue & Déploiement Continu",
  author: "Olivier Barais",
  date: datetime(year: 2026, month: 9, day: 1),
)

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 2.5cm, left: 2.5cm, right: 2.5cm),
  header: context {
    if counter(page).get().first() > 1 [
      #set text(size: 8pt, fill: luma(130))
      #grid(columns: (1fr, 1fr),
        [DevSecOps — Cours 4 · Université de Rennes],
        align(right)[Olivier Barais]
      )
      #line(length: 100%, stroke: 0.5pt + luma(200))
    ]
  },
  footer: context [
    #set text(size: 8pt, fill: luma(130))
    #line(length: 100%, stroke: 0.5pt + luma(200))
    #v(2pt)
    #grid(columns: (1fr, 1fr),
      [IRISA / DiverSE · 2026],
      align(right)[Page #counter(page).display("1")]
    )
  ]
)

#set text(font: "New Computer Modern", size: 10.5pt, lang: "fr")
#set par(justify: true, leading: 0.65em, spacing: 1.2em)
#set heading(numbering: "1.1")

#show heading.where(level: 1): it => {
  v(1.5em)
  block(
    fill: rgb("#1e40af"),
    radius: 4pt,
    inset: (x: 10pt, y: 6pt),
    width: 100%,
    text(fill: white, size: 14pt, weight: "bold")[#it.body]
  )
  v(0.5em)
}

#show heading.where(level: 2): it => {
  v(0.8em)
  text(size: 12pt, weight: "bold", fill: rgb("#1d4ed8"))[#it.body]
  v(0.3em)
}

#show heading.where(level: 3): it => {
  v(0.5em)
  text(size: 11pt, weight: "bold", fill: rgb("#374151"))[#it.body]
  v(0.2em)
}

// Boîte d'alerte
#let alert(color: red, icon: "⚠", body) = block(
  fill: color.lighten(90%),
  stroke: 0.8pt + color,
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[
  #text(weight: "bold")[#icon  ] #body
]

// Boîte d'exemple
#let example(title, body) = block(
  fill: rgb("#f0f9ff"),
  stroke: (left: 3pt + rgb("#0ea5e9")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#0369a1"))[Exemple — #title] \
  #v(4pt)
  #body
]

// Boîte de définition
#let definition(term, body) = block(
  fill: rgb("#f5f3ff"),
  stroke: (left: 3pt + rgb("#7c3aed")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#6d28d9"))[Définition — #term] \
  #v(4pt)
  #body
]

// Boîte de retenir
#let keypoint(body) = block(
  fill: rgb("#fff7ed"),
  stroke: (left: 3pt + rgb("#ea580c")),
  inset: (left: 12pt, right: 10pt, top: 8pt, bottom: 8pt),
  width: 100%,
)[
  #text(weight: "bold", fill: rgb("#c2410c"))[À retenir] \
  #v(4pt)
  #body
]

// Style des blocs de code
#show raw.where(block: true): it => block(
  fill: rgb("#0f172a"),
  radius: 4pt,
  inset: 10pt,
  width: 100%,
)[#text(fill: rgb("#94a3b8"), size: 9pt, font: "New Computer Modern")[#it]]

// ============================================================
// PAGE DE TITRE
// ============================================================

#align(center)[
  #v(2cm)
  #block(
    fill: rgb("#1e3a8a"),
    radius: 8pt,
    inset: 20pt,
    width: 90%,
  )[
    #text(fill: white, size: 11pt)[DevSecOps — Université de Rennes · IRISA / DiverSE]
    #v(8pt)
    #text(fill: white, size: 20pt, weight: "bold")[Cours 4]
    #v(4pt)
    #text(fill: rgb("#93c5fd"), size: 15pt)[Intégration Continue & Déploiement Continu]
    #v(4pt)
    #text(fill: rgb("#bfdbfe"), size: 11pt)[CI · CD · GitHub Actions · Jenkins · Sécurité des pipelines]
  ]

  #v(1.5cm)

  #grid(
    columns: (1fr, 1fr),
    gutter: 1cm,
    align(center)[
      #text(size: 10pt, fill: luma(80))[*Auteur*\ Olivier Barais]
    ],
    align(center)[
      #text(size: 10pt, fill: luma(80))[*Institution*\ IRISA / DiverSE\ Université de Rennes]
    ]
  )

  #v(0.5cm)
  #text(size: 9pt, fill: luma(120))[Année universitaire 2026–2027]

  #v(1.5cm)

  #block(
    fill: luma(240),
    radius: 4pt,
    inset: 10pt,
    width: 90%,
  )[
    #text(size: 9.5pt)[
      *Résumé.* Ce polycopié accompagne le cours 4 du module DevSecOps. Il couvre les pratiques
      d'intégration continue (CI) et de déploiement continu (CD) : définitions, objectifs, cycle vertueux
      de maturité, outillage (Jenkins, GitHub Actions, GitLab CI), stratégies de déploiement, et sécurité
      des pipelines. Une attention particulière est portée aux vecteurs d'attaque ciblant les environnements
      CI/CD et aux bonnes pratiques pour s'en prémunir.
    ]
  ]
]

#pagebreak()

// ============================================================
// TABLE DES MATIÈRES
// ============================================================

#outline(title: "Table des matières", depth: 2, indent: 1em)

#pagebreak()

// ============================================================
// 1. INTRODUCTION — QU'EST-CE QUE L'INTÉGRATION CONTINUE ?
// ============================================================

= Introduction — Qu'est-ce que l'intégration continue ?

L'intégration continue (IC, ou CI pour _Continuous Integration_ en anglais) est une pratique
fondamentale du développement logiciel moderne. Elle consiste à intégrer fréquemment les
modifications de code dans un dépôt partagé, chaque intégration étant validée automatiquement
par un build et une suite de tests.

== Définitions

Deux définitions font autorité dans la communauté :

#definition("Intégration continue (Wikipedia)")[
  « L'intégration continue est un ensemble de pratiques utilisées en génie logiciel consistant
  à vérifier à chaque modification de code source que le résultat des modifications ne produit
  pas de régression dans l'application développée. »
]

#definition("Intégration continue (Fowler & Foemmel, 2006)")[
  « Continuous Integration is a software development practice where members of a team integrate
  their work frequently, usually each person integrates at least daily --- leading to multiple
  integrations per day. Each integration is verified by an automated build (including test) to
  detect integration errors as quickly as possible. » @fowler2006ci
]

Ces deux définitions mettent en évidence trois composantes essentielles : la fréquence d'intégration
(au moins quotidienne), l'automatisation du build, et la vérification par des tests automatisés.

== Le problème de l'« Integration Hell »

Sans CI, les équipes travaillent souvent sur des branches longues (plusieurs semaines ou mois).
Lorsque vient le moment de fusionner ces branches, les conflits s'accumulent et leur résolution
peut prendre autant de temps que le développement lui-même. Cette situation, connue sous le nom
d'_integration hell_, se manifeste par :

- Des conflits de merge massifs et coûteux à résoudre
- Des bugs liés à l'interaction entre fonctionnalités développées en parallèle
- Une incertitude sur l'état réel du logiciel à tout moment
- Une peur de toucher au code existant (paralysie)

#keypoint[
  *Principe fondateur de la CI :* si une tâche est difficile et douloureuse, la faire plus souvent
  la rend plus facile. Appliqué à l'intégration : intégrer chaque jour plutôt que tous les mois
  transforme une opération risquée en routine maîtrisée @humble2010.
]

== Objectifs de l'intégration continue

L'IC vise quatre objectifs complémentaires :

*1. Maintenir l'équipe en phase.* En intégrant fréquemment, chaque développeur dispose d'un
trunk toujours représentatif de l'état réel du projet. Les divergences restent faibles et les
conflits circonscrits.

*2. Limiter les risques et la complexité.* Chaque commit représente un delta minimal par rapport
à la version précédente. Si un problème survient, il est facile de l'isoler et de le corriger.

*3. Compiler et tester à intervalles réguliers.* L'automatisation garantit que le build est
reproductible sur un serveur neutre (et pas seulement « ça marche chez moi »). Les tests
automatisés constituent un filet de sécurité qui détecte les régressions immédiatement.

*4. Produire une livraison potentielle à chaque instant.* Le trunk doit toujours être dans un
état déployable. Cette propriété est le fondement du déploiement continu (CD).

Des études académiques ont mesuré l'impact de la CI sur la qualité logicielle et la productivité
des équipes. Vasilescu et al. @vasilescu2015quality ont montré, sur un corpus de projets GitHub,
que les équipes pratiquant la CI mergent plus de pull requests, trouvent plus de bugs, et publient
plus souvent. Hilton et al. @hilton2016ci confirment que la CI réduit les délais de feedback et
améliore la qualité perçue par les développeurs.

// ============================================================
// 2. POURQUOI ET COMMENT AUTOMATISER
// ============================================================

= Pourquoi et comment automatiser

== Les bénéfices de l'automatisation

Automatiser le pipeline de build et de tests apporte trois types de bénéfices @humble2010 :

*Gagner du temps.* Les tâches répétitives --- compilation, exécution des tests, packaging ---
sont réalisées en quelques minutes par la machine, là où un développeur prendrait des heures
à les exécuter manuellement et de façon fiable. Les développeurs se concentrent sur la création
de valeur.

*Gagner en confiance.* Chaque commit est validé de façon objective et systématique. Le feedback
est immédiat et ne dépend pas de la rigueur d'un individu particulier. Les équipes osent
refactorer et expérimenter car elles savent qu'une régression sera détectée aussitôt.

*Réduire la documentation manuelle.* Les scripts de build, les fichiers de configuration du
pipeline et les tests constituent une documentation vivante du processus de livraison. Ils
permettent à un nouveau membre de l'équipe de comprendre et reproduire le build sans documentation
supplémentaire.

== Les quatre composants fondamentaux

Pour démarrer une démarche CI, quatre composants sont nécessaires :

#grid(
  columns: (auto, 1fr),
  gutter: 8pt,
  [*1. Gestionnaire de versions (VCS)*],
  [Git, SVN ou équivalent. Tout le code source doit être versionné. Sans VCS, l'IC est
  impossible. Le VCS est la source de vérité unique (_single source of truth_).],
  [*2. Tests automatisés*],
  [JUnit (Java), pytest (Python), Jest (JavaScript)… Sans tests, l'IC ne peut que vérifier
  que le code _compile_, non qu'il _fonctionne_ correctement. Les tests sont la pierre
  angulaire de la CI.],
  [*3. Scripts d'automatisation*],
  [Make, Maven, npm scripts, ou tout autre outil de build. Les étapes de compilation,
  packaging et déploiement doivent être scriptées et reproductibles en une seule commande.
  Un ordonnanceur (crontab, webhook) déclenche le pipeline à chaque commit.],
  [*4. Outils de communication*],
  [Email, Slack, dashboard de CI. Le feedback doit être visible de toute l'équipe.
  Si le build est cassé, tout le monde doit le savoir immédiatement.],
)

#keypoint[
  *La règle d'or :* si le build est cassé, _tout s'arrête_ jusqu'à ce qu'il soit réparé.
  Un build cassé ignoré détruit la confiance dans le pipeline et rend la CI inutile.
]

// ============================================================
// 3. LE PIPELINE CI
// ============================================================

= Le pipeline d'intégration continue

== Concept et anatomie

Un pipeline CI est une séquence d'étapes automatisées déclenchée par chaque commit ou pull request.
Son objectif est de produire un signal clair (succès ou échec) le plus rapidement possible.

```
  Push / Pull Request
         │
         ▼
  ┌───────────────────────────────────────────────┐
  │                Pipeline CI                   │
  │                                              │
  │  Checkout → Build → Tests → Lint → Rapport  │
  └───────────────────────────────────────────────┘
         │            │          │
         │            │          └─► Notification (succès/échec)
         │            └────────────► Artefact (JAR, wheel, image…)
         └─────────────────────────► Badge de statut
```

Un bon pipeline CI respecte trois propriétés @humble2010 :
- *Rapidité* : le feedback doit arriver en moins de 10 minutes idéalement
- *Reproductibilité* : le même résultat sur n'importe quelle machine, à n'importe quel moment
- *Transparence* : logs accessibles, historique des builds visible par toute l'équipe

== La pyramide des tests

La pyramide des tests @cohn2009agile définit une hiérarchie des types de tests selon leur
vitesse d'exécution, leur coût, et leur granularité :

```
              ▲
             /E2E\       ← Lents, coûteux, peu nombreux (~10%)
            /─────\
           /  Intég \    ← Tests d'intégration (DB, API, service) (~20%)
          /──────────\
         /  Unitaires \  ← Rapides, nombreux, isolés (~70%)
        /──────────────\
```

La base de la pyramide (tests unitaires) doit représenter la majorité des tests : ils sont
rapides (millisecondes), isolés (pas de dépendances externes), et faciles à maintenir. Les
tests d'intégration vérifient l'interaction entre composants (base de données, API externes).
Les tests end-to-end (E2E) simulent un vrai utilisateur mais sont lents et fragiles.

#example("Configuration de couverture de code avec pytest")[
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
]

== Reporting et observabilité

Un tableau de bord CI expose plusieurs métriques essentielles :

- *Couverture de code* : pourcentage de lignes et de branches testées. Des outils comme
  JaCoCo (Java), Coverage.py (Python) ou Istanbul (JavaScript) mesurent cette couverture
  et l'historisent build par build.

- *Temps de build* : chaque étape du pipeline est chronométrée. Un ralentissement progressif
  indique une dette technique (tests de plus en plus lents, dépendances lourdes).

- *Violations de règles qualité* : PMD, Checkstyle, SonarQube détectent les _code smells_,
  les duplications et les problèmes de sécurité dans le code source.

- *Résultats de tests de performance* : JMeter, Gatling ou k6 mesurent les temps de réponse
  et les taux d'erreur sous charge, build par build.

== Le cycle vertueux de l'intégration continue

La mise en place d'une CI est progressive. On distingue cinq niveaux de maturité @fowler2006ci :

#grid(
  columns: (auto, 1fr),
  gutter: 8pt,
  [*① Compilation manuelle*],
  [À la demande, le développeur compile et lance les tests localement. Pas encore automatisé.],
  [*② Build planifié*],
  [Un serveur exécute automatiquement checkout + compilation + tests à intervalles réguliers
  (par heure via crontab) et envoie un email en cas d'échec.],
  [*③ Releases presse-bouton*],
  [Hebdomadaire. Le pipeline inclut la création d'une branche de release, l'exécution des tests
  de non-régression, le packaging et la publication d'une release candidate.],
  [*④ Installation et déploiement*],
  [Mensuel. Le pipeline déploie automatiquement sur un environnement de recette, met à jour
  les configurations et exécute les tests d'acceptance.],
  [*⑤ Monitoring continu*],
  [En continu. Le système surveille la production, remonte les anomalies via des alertes
  (email, SMS, dashboard), et intègre les métriques de log dans la boucle de feedback.],
)

Chaque niveau apporte plus de confiance et réduit le risque par rapport au précédent. La
progression vers le niveau 5 correspond à la pratique du déploiement continu (CD) décrite
dans la section suivante.

// ============================================================
// 4. OUTILS D'INTÉGRATION CONTINUE
// ============================================================

= Outils d'intégration continue

== Jenkins et son histoire

Jenkins est aujourd'hui le serveur CI _on-premise_ de référence. Son histoire illustre les
tensions entre communauté open source et grands acteurs industriels.

*Hudson (2004--2011).* Créé en 2004 par Kohsuke Kawaguchi chez Sun Microsystems, Hudson est
l'un des premiers serveurs CI à populariser le concept de _pipeline as code_ et les plugins
d'extension. Lors du rachat de Sun par Oracle en 2010, des tensions sur la gouvernance du
projet et la propriété de la marque éclatent.

*Fork vers Jenkins (2011).* La communauté fork Hudson en janvier 2011 et crée Jenkins, placé
sous la gouvernance de la Linux Foundation @jenkins-docs. Jenkins devient rapidement le serveur
CI le plus déployé au monde avec plus de 1 800 plugins disponibles.

#example("Jenkinsfile — Pipeline déclaratif")[
```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps { sh 'mvn clean package -DskipTests' }
        }
        stage('Test') {
            steps { sh 'mvn test' }
            post {
                always { junit 'target/surefire-reports/*.xml' }
            }
        }
        stage('Quality') {
            steps { sh 'mvn sonar:sonar' }
        }
        stage('Deploy') {
            when { branch 'main' }
            steps { sh './deploy.sh staging' }
        }
    }
    post {
        failure {
            mail to: 'team@example.com',
                 subject: "Build failed: ${env.JOB_NAME}"
        }
    }
}
```
]

Le `Jenkinsfile` est stocké dans le dépôt Git à côté du code source. Cette approche
_infrastructure as code_ garantit que l'historique du pipeline est versionné au même titre
que le code applicatif.

== Panorama des outils CI modernes

Le marché des outils CI/CD s'est considérablement structuré autour de deux paradigmes :
les solutions SaaS intégrées à la forge Git, et les solutions _on-premise_ déployées par
les organisations.

#figure(
  table(
    columns: (1.5fr, 1fr, 2fr, 1.5fr),
    inset: 7pt,
    align: left,
    fill: (_, row) => if row == 0 { rgb("#1e40af") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    table.header(
      text(fill: white, weight: "bold")[Outil],
      text(fill: white, weight: "bold")[Modèle],
      text(fill: white, weight: "bold")[Points forts],
      text(fill: white, weight: "bold")[Cas d'usage],
    ),
    [GitHub Actions], [SaaS / on-prem], [Intégré à GitHub, marketplace d'actions], [Projets GitHub],
    [GitLab CI], [SaaS / on-prem], [Intégré à GitLab, Auto DevOps, registre intégré], [Projets GitLab],
    [Jenkins], [On-prem], [Très configurable, 1 800+ plugins, Jenkinsfile], [Enterprise legacy],
    [CircleCI], [SaaS], [Rapide, bonne DX, orbs réutilisables], [Startups, OSS],
    [Travis CI], [SaaS], [Simple, historique open source], [OSS (en déclin)],
    [Tekton], [Kubernetes], [Cloud-native, pipelines déclaratifs, CNCF], [Kubernetes GitOps],
    [ArgoCD], [Kubernetes], [CD déclaratif GitOps, synchronisation continue], [CD sur K8s],
  ),
  caption: [Panorama des principaux outils CI/CD en 2026]
)

La tendance générale est au *YAML-first* (configuration déclarative), à l'intégration native
avec la forge Git (un commit = un pipeline), et aux runners éphémères (conteneurs jetés après
chaque build) qui éliminent les problèmes d'environnement persistant.

== GitHub Actions en détail

GitHub Actions est devenu le standard de facto pour les projets hébergés sur GitHub @github-actions-docs.
Son modèle repose sur les concepts suivants :

#figure(
  table(
    columns: (1fr, 2.5fr),
    inset: 7pt,
    align: left,
    fill: (_, row) => if row == 0 { rgb("#1e40af") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    table.header(
      text(fill: white, weight: "bold")[Concept],
      text(fill: white, weight: "bold")[Description],
    ),
    [Workflow], [Automatisation définie dans un fichier YAML sous `.github/workflows/`],
    [Event], [Déclencheur : `push`, `pull_request`, `schedule`, `workflow_dispatch`, etc.],
    [Job], [Ensemble d'étapes s'exécutant sur un runner (éventuellement en parallèle)],
    [Step], [Commande shell ou action individuelle],
    [Action], [Bloc réutilisable publié sur le marketplace GitHub],
    [Runner], [Machine d'exécution (GitHub-hosted `ubuntu-latest` ou self-hosted)],
    [Artifact], [Fichier produit par le workflow (JAR, rapport, image Docker, etc.)],
    [Secret], [Variable chiffrée injectée dans le workflow au moment de l'exécution],
  ),
  caption: [Concepts clés de GitHub Actions]
)

#example("Workflow CI minimal en Python avec GitHub Actions")[
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
        run: pytest --tb=short --cov=src
```
]

// ============================================================
// 5. LE DÉPLOIEMENT CONTINU (CD)
// ============================================================

= Le déploiement continu (CD)

== CI, Continuous Delivery et Continuous Deployment

Le terme « CD » recouvre en réalité deux pratiques distinctes @humble2010 :

#definition("Continuous Delivery")[
  Chaque commit qui passe les tests automatisés produit un artefact prêt à être déployé en
  production. Le déploiement effectif reste une décision humaine (un bouton à appuyer).
]

#definition("Continuous Deployment")[
  Chaque commit qui passe les tests automatisés est déployé _automatiquement_ en production,
  sans intervention humaine.
]

```
  Commit → CI (build+test) → Artifact → [approbation manuelle] → Production
                                               ↑
                              Continuous Delivery s'arrête ici
                              Continuous Deployment l'automatise
```

En pratique, la plupart des organisations adoptent le Continuous Delivery pour la production
(avec une approbation humaine) et le Continuous Deployment pour les environnements de staging
et de recette. En DevSecOps, on ajoute des *security gates* (portes de sécurité) entre chaque
étape : scan SAST, audit des dépendances, scan d'image Docker, etc.

== Pipeline CD complet avec sécurité intégrée

#example("Pipeline CD complet (GitHub Actions)")[
```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: mvn clean package

  security-scan:
    needs: build
    steps:
      - name: Scan SAST
        uses: github/codeql-action/analyze@v3
      - name: Audit dépendances
        run: pip-audit

  build-image:
    needs: security-scan
    steps:
      - name: Build Docker image
        run: docker build -t app:${{ github.sha }} .
      - name: Scan image (Trivy)
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: app:${{ github.sha }}
          exit-code: '1'           # Bloque si vulnérabilité critique
      - name: Push vers registre
        run: docker push ghcr.io/org/app:${{ github.sha }}

  deploy-staging:
    needs: build-image
    environment: staging           # Approbation requise sur GitHub
    steps:
      - name: Deploy
        run: kubectl set image deployment/app app=ghcr.io/org/app:${{ github.sha }}
```
]

L'ordre des étapes est délibéré : la sécurité est vérifiée _avant_ la construction de l'image
Docker et _avant_ tout déploiement. Un scan qui détecte une vulnérabilité critique bloque
le pipeline sans intervention manuelle.

== Stratégies de déploiement

Le déploiement en production soulève la question du *risque de mise en service*. Plusieurs
stratégies existent, offrant des compromis différents entre simplicité, risque et capacité
de rollback @fowler-bluegreen @fowler-canary @humble2010 :

#figure(
  table(
    columns: (1.5fr, 2fr, 1fr, 1fr),
    inset: 7pt,
    align: left,
    fill: (_, row) => if row == 0 { rgb("#1e40af") } else if calc.odd(row) { rgb("#f8fafc") } else { white },
    table.header(
      text(fill: white, weight: "bold")[Stratégie],
      text(fill: white, weight: "bold")[Principe],
      text(fill: white, weight: "bold")[Risque],
      text(fill: white, weight: "bold")[Rollback],
    ),
    [Recreate], [Stop v1 → Start v2 (downtime accepté)], [Élevé], [Lent],
    [Rolling update], [Remplacement progressif instance par instance], [Faible], [Automatique],
    [Blue / Green], [Deux environnements complets ; bascule du load balancer], [Nul], [Instantané],
    [Canary], [1--5 % du traffic vers v2 d'abord, puis montée en charge], [Très faible], [Instantané],
    [Feature flags], [Code déployé mais fonctionnalité activée / désactivée par config], [Nul], [Par flag],
  ),
  caption: [Stratégies de déploiement et leurs compromis]
)

*Blue/Green.* Deux environnements de production identiques coexistent. La nouvelle version
est déployée sur l'environnement « vert » pendant que l'environnement « bleu » sert le traffic.
La bascule s'effectue au niveau du load balancer. En cas de problème, le retour en arrière
est immédiat @fowler-bluegreen.

*Canary.* Le nom vient des canariers que les mineurs emmenaient pour détecter les gaz
toxiques. Un faible pourcentage du traffic (1 à 5 %) est dirigé vers la nouvelle version.
Les métriques (taux d'erreur, latence) sont surveillées. Si tout va bien, le pourcentage
augmente progressivement jusqu'à 100 % @fowler-canary.

*Feature flags.* Le déploiement est dissocié de l'activation. Le code de la nouvelle
fonctionnalité est déployé mais désactivé par défaut. L'activation se fait par configuration,
permettant des tests en production sur un sous-ensemble d'utilisateurs @rahman2015synthesizing.

#keypoint[
  Selon le rapport DORA 2023 @dora2023, les équipes performantes déploient en production
  plusieurs fois par jour avec un taux de changement échoué inférieur à 5 % et un temps
  de restauration inférieur à une heure. Ces métriques sont rendues possibles par la
  combinaison CI/CD + déploiements progressifs + monitoring.
]

// ============================================================
// 6. CI/CD ET SÉCURITÉ
// ============================================================

= CI/CD et sécurité

== Le pipeline CI/CD comme vecteur d'attaque

Le pipeline CI/CD est l'une des cibles les plus attrayantes pour un attaquant. La raison
est simple : il dispose d'un accès privilégié à l'ensemble de la chaîne de production.

*Accès typiques d'un pipeline CI/CD :*

```yaml
env:
  DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
  AWS_ACCESS_KEY:  ${{ secrets.AWS_ACCESS_KEY }}
  NPM_TOKEN:       ${{ secrets.NPM_TOKEN }}
  GITHUB_TOKEN:    ${{ secrets.GITHUB_TOKEN }}
  KUBECONFIG:      ${{ secrets.KUBECONFIG }}
  SIGNING_KEY:     ${{ secrets.CODE_SIGNING_KEY }}
```

Si le pipeline est compromis, l'attaquant peut publier des paquets malveillants sur npm ou
PyPI sous l'identité légitime de l'organisation, pousser des images Docker malveillantes
dans le registre de production, accéder à l'infrastructure cloud et exfiltrer des données
sensibles, ou signer des artefacts avec la clé de signature officielle.

== L'incident SolarWinds (2020)

L'incident SolarWinds est l'exemple le plus documenté d'une attaque ciblant un build system
@solarwinds-cisa @solarwinds-analysis. Des attaquants (attribués à l'APT29 russe) ont compromis
l'environnement de build d'Orion, le logiciel de monitoring réseau de SolarWinds. Ils ont injecté
une backdoor baptisée SUNBURST directement dans le processus de compilation, _avant_ la signature
cryptographique des binaires.

Le binaire livré était signé avec la clé légitime de SolarWinds. La backdoor a ainsi été
distribuée à environ 18 000 clients, dont des agences gouvernementales américaines et de grandes
entreprises technologiques. La détection de l'attaque a pris plusieurs mois.

#alert(color: red, icon: "🚨")[
  *Leçon SolarWinds :* la signature cryptographique ne protège pas si le code signé a été
  altéré _avant_ la signature. La sécurité du build system lui-même est critique.
]

== L'incident Codecov (2021)

En avril 2021, le service Codecov --- utilisé par des milliers de projets pour l'upload de
rapports de couverture de code dans les pipelines CI --- a été compromis @codecov-breach.
Les attaquants ont modifié le script Bash d'upload de Codecov pour y intégrer une exfiltration
des variables d'environnement CI (incluant tokens, clés d'API, credentials).

Ce cas illustre un vecteur d'attaque particulier : la compromission d'un *outil tiers intégré
au pipeline*. Des centaines d'organisations ont eu leurs secrets exposés à travers un seul
point de défaillance.

== OWASP Top 10 CI/CD Security Risks

L'OWASP a publié en 2022 les dix risques de sécurité les plus critiques pour les environnements
CI/CD @owasp-cicd-top10 :

#grid(
  columns: (auto, 1fr),
  gutter: 6pt,
  [*CICD-SEC-01*], [Insufficient Flow Control Mechanisms — absence de contrôles d'approbation],
  [*CICD-SEC-02*], [Inadequate Identity and Access Management — droits trop larges],
  [*CICD-SEC-03*], [Dependency Chain Abuse — typosquatting, dépendances malveillantes],
  [*CICD-SEC-04*], [Poisoned Pipeline Execution (PPE) — exécution de code arbitraire via PR],
  [*CICD-SEC-05*], [Insufficient PBAC (Pipeline-Based Access Controls)],
  [*CICD-SEC-06*], [Insufficient Credential Hygiene — secrets en clair dans les logs/vars],
  [*CICD-SEC-07*], [Insecure System Configuration — mauvaise config des runners],
  [*CICD-SEC-08*], [Ungoverned Usage of Third-Party Services — actions non vérifiées],
  [*CICD-SEC-09*], [Improper Artifact Integrity Validation — absence de vérification d'intégrité],
  [*CICD-SEC-10*], [Insufficient Logging and Visibility — pas d'audit trail],
)

== Bonnes pratiques de sécurité CI/CD

=== Principe de moindre privilège

Le workflow GitHub Actions doit déclarer explicitement les permissions dont il a besoin.
Par défaut, `GITHUB_TOKEN` a des droits en écriture sur tout le dépôt, ce qui est trop large.

```yaml
permissions:
  contents: read        # Lire le code seulement
  packages: write       # Écrire des packages si nécessaire
  security-events: write  # Pour les scans de sécurité
  # Tout le reste : non accordé implicitement
```

Le NIST recommande dans SP 800-204D @nist-sp800-204d d'appliquer le principe de moindre
privilège à chaque étape du pipeline, avec des secrets distincts par environnement.

=== Épinglage des actions par hash cryptographique

Les tags Git (comme `actions/checkout@v4`) peuvent être déplacés par un attaquant ayant
compromis le dépôt de l'action. Épingler par hash SHA-1 garantit l'immuabilité :

```yaml
# ❌ Dangereux : la tag peut être déplacée silencieusement
uses: actions/checkout@v4

# ✅ Sûr : hash SHA-1 immuable (vérifiable via GitHub)
uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683
```

Le GitHub Security Lab @github-actions-security documente ce vecteur d'attaque, appelé
_Poisoned Pipeline Execution_ (PPE), dans lequel une action malveillante injectée via un
tag déplacé exfiltre les secrets du runner.

=== Runners éphémères

Les runners self-hosted persistants accumulent des artefacts de builds précédents, des
variables d'environnement résiduelles, et potentiellement des processus malveillants laissés
par un build compromis. Les runners éphémères (conteneurs jetés après chaque build) éliminent
ce risque.

=== Autres mesures essentielles

- *Rotation régulière des secrets* : les tokens et clés d'API doivent avoir une durée de vie
  limitée et être renouvelés périodiquement
- *Branch protection rules* : imposer les revues de code et les status checks CI avant tout
  merge sur les branches protégées
- *Audit des logs CI/CD* : conserver l'historique des exécutions et alerter sur les patterns
  anormaux (secrets détectés dans les logs, temps d'exécution anormalement long)
- *Vérification d'intégrité des artefacts* : utiliser des mécanismes comme SLSA @slsa-framework
  ou Sigstore pour vérifier la provenance des artefacts

#keypoint[
  *Le pipeline CI/CD est la colonne vertébrale de votre supply chain logicielle.* Le compromettre
  revient à compromettre tous vos utilisateurs simultanément. Les mêmes contrôles de sécurité
  appliqués au code doivent l'être au pipeline lui-même : revues, tests, principe de moindre
  privilège, et auditabilité @cisa-securing-ssc.
]

// ============================================================
// 7. CONCLUSION
// ============================================================

= Conclusion

L'intégration continue et le déploiement continu sont aujourd'hui des pratiques indissociables
du développement logiciel professionnel. Leurs bénéfices sont documentés académiquement
@vasilescu2015quality @hilton2016ci @shahin2017cicd et mesurés à grande échelle par le
programme DORA @dora2023.

Les points essentiels à retenir :

- *CI = fréquence + automatisation + feedback rapide.* Intégrer souvent (au moins quotidiennement)
  réduit les risques et améliore la qualité.

- *Le pipeline CI doit être rapide, reproductible et transparent.* Un feedback en plus de dix
  minutes n'est pas utilisable par les développeurs.

- *CD = Delivery + Deployment.* Le Continuous Delivery garantit que le code est toujours déployable ;
  le Continuous Deployment automatise ce déploiement.

- *Les stratégies de déploiement progressif* (blue/green, canary, feature flags) réduisent le risque
  de mise en service tout en maintenant une cadence élevée.

- *Le pipeline CI/CD est une surface d'attaque critique.* Les incidents SolarWinds et Codecov
  démontrent que compromettre le build system permet d'atteindre des milliers d'utilisateurs.

- *DevSecOps = sécurité intégrée dans le pipeline*, pas ajoutée a posteriori. Chaque étape du
  pipeline doit inclure des vérifications de sécurité automatisées.

#bibliography("refs.bib", title: "Références", style: "ieee")
