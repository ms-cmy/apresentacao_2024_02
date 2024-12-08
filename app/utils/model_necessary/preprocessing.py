from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.cluster import KMeans

class KMeansTransformer(BaseEstimator, TransformerMixin):
    def __init__(self, n_clusters=5):
        self.n_clusters = n_clusters
        self.kmeans = KMeans(n_clusters=self.n_clusters, random_state=42)

    def fit(self, X, y=None):
        self.kmeans.fit(X)
        return self

    def transform(self, X):
        cluster_labels = self.kmeans.predict(X)
        return cluster_labels.reshape(-1, 1)