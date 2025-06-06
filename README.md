# 🎬 Système de recommandation basé sur MovieLens

## 📘 Description du projet

Ce projet a pour objectif de concevoir un système de recommandation basé sur les évaluations de films du jeu de données [MovieLens](https://grouplens.org/datasets/movielens/). Il s’articule autour de plusieurs étapes :

1. **Conception d’un modèle en étoile** pour l’entrepôt de données.
2. **Développement du processus ETL** via Google Colab.
3. **Construction de la base de données SQL Server**.
4. **Exploitation OLAP** pour l’analyse multidimensionnelle.
5. **Clustering et classification des utilisateurs** pour la recommandation.

📌 Technologies utilisées
Google Colab (Python, Pandas)

SQL Server

Jupyter Notebook (ETL.ipynb fourni)

Data Visualization (via figures intégrées dans le rapport)

## 📊 Jeu de données

Nous utilisons les fichiers :
- `movies.csv`
- `ratings.csv`

Les fichiers `tags.csv` et `links.csv` sont exclus de cette version du projet pour rester centrés sur les évaluations et les films.

## 🧱 Modèle en étoile

Le modèle de données comprend :

- **Table de faits** : `ratings_fact`
- **Tables de dimensions** :
  - `table_movies`
  - `table_utilisateur`

Relations :
- `ratings_fact.movieId` → `table_movies.movieId`
- `ratings_fact.userId` → `table_utilisateur.userId`

## 🔄 Processus ETL

Les étapes du processus ETL sont :
- Importation des données dans Google Colab
- Échantillonnage stratifié (10%) pour réduire le volume de données
- Formatage des données (`datetime`, `int`)
- Chargement des données dans SQL Server via l’outil **Import Flat File**

## 🗄️ Base de données SQL Server

Les données sont structurées via des clés primaires et étrangères :
```sql
ALTER TABLE ratings_fact
ADD CONSTRAINT FK_ratings_fact_userId
FOREIGN KEY (userId) REFERENCES table_Utilisateur(userId)
ON DELETE CASCADE
ON UPDATE CASCADE;

ALTER TABLE ratings_fact
ADD CONSTRAINT FK_ratings_fact_movieId
FOREIGN KEY (movieId) REFERENCES table_movies(movieId)
ON DELETE CASCADE
ON UPDATE CASCADE;

# 📈 Analyse avancée et Recommandation basée sur MovieLens

## 🧠 Partie II — OLAP, Clustering et Classification

Cette deuxième partie approfondit l’analyse des données de MovieLens à travers des opérations OLAP, du **clustering** non supervisé, et une **classification supervisée** des utilisateurs. Ces méthodes permettent de mieux comprendre les préférences cinématographiques et de prédire les comportements de nouveaux utilisateurs.

---

## 🔎 1. Opérations OLAP

L'analyse OLAP (On-Line Analytical Processing) permet d'extraire des insights à partir des données à l'aide d'opérations comme `Slice`, `Dice`, `Drill-down` et `Roll-up`.

### 🧊 SLICE
- **Exemple 1** : Obtenir les évaluations pour le film *Grumpier Old Men (1995)*.
- **Exemple 2** : Obtenir les évaluations des films appartenant au genre *Drama*.

### 🎲 DICE
- **Exemple 1** : Obtenir les évaluations des films *Comedy* avec une note > 3.
- **Exemple 2** : Évaluations des genres *Drama* ou *Comedy* par des utilisateurs actifs (> 3 films évalués).

### 🔽 DRILL-DOWN
- **Exemple 1** : Détail des évaluations pour *Grumpier Old Men (1995)* (genre *Drama*).
- **Exemple 2** : Nombre d’évaluations par année (agrégation temporelle).

### 🔼 ROLL-UP
- **Exemple 1** : Total d’évaluations par genre (avec `WITH ROLLUP`).
- **Exemple 2** : Moyenne des notes pour chaque film, triée par évaluation.

📄 *Les requêtes SQL sont fournies dans le fichier `OLAP_operations.sql`.*

---

## 👥 2. Profil utilisateur et vectorisation

### Étapes principales :
1. **Jointure** des tables `movies` et `ratings` pour enrichir les profils utilisateurs.
2. Utilisation de `MultiLabelBinarizer` de Scikit-learn pour encoder les genres de films.
3. Création des **vecteurs utilisateurs** : Moyenne pondérée des genres par utilisateur, basée sur ses notes.

---

## 📊 3. Clustering des utilisateurs

### ⚙️ Méthodologie :
- **Normalisation** des vecteurs avec `StandardScaler`.
- **K-means** appliqué avec `n_clusters=3`.
- Visualisation des clusters (projection PCA).

### 📌 Interprétation :
- **Cluster jaune** : Utilisateurs aux goûts variés.
- **Clusters violet et vert** : Profils plus homogènes (fortes préférences spécifiques).
- Segmentation utile pour recommandations ciblées.

📈 Les clusters sont visualisés avec UMAP ou PCA pour observer les comportements utilisateurs.

---

## 🧮 4. Classification supervisée

### 🛠️ Modèle : Random Forest Classifier

#### Pipeline :
1. **Préparation des données** : vecteurs utilisateurs (features) et clusters (target).
2. **Split** : 70% entraînement, 30% test.
3. **Entraînement** avec `.fit()`, prédiction avec `.predict()`.
4. **Évaluation** : Rapport de classification (precision, recall, F1-score).

### ✅ Résultats :
- **Précision globale** : 99%
- **F1-score moyen** : 0.98
- **Cluster 1** dominant : 22 432 utilisateurs
- Très bonne performance de généralisation du modèle.

---

## 📌 Conclusion

Ce projet démontre l'efficacité d'une approche analytique intégrée pour un système de recommandation :

- ✔️ **Entrepôt de données** robuste via SQL Server
- ✔️ **Exploration OLAP** des tendances et préférences
- ✔️ **Clustering** performant pour la segmentation
- ✔️ **Classification** précise pour prédire les profils

🔍 La réduction de dimensionnalité (PCA) permet une interprétation visuelle enrichissante.

📊 **Impact** : Une base solide pour un moteur de recommandation personnalisée, axé sur le comportement utilisateur.

