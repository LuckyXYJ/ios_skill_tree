package 图;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Set;

public abstract class Graph<V, E> {
    protected WeightManager<E> weightManager;

    public Graph() {}

    public Graph(WeightManager<E> weightManager) {
        this.weightManager = weightManager;
    }

    public abstract int edgesSize();
    public abstract int verticesSize();

    public abstract void addVertex(V v);
    public abstract void addEdge(V from, V to);
    public abstract void addEdge(V from, V to, E weight);

    public abstract void removeVertex(V v);
    public abstract void removeEdge(V from, V to);

    public abstract void bfs(V begin, VertexVisitor<V> visitor);
    public abstract void dfs(V begin, VertexVisitor<V> visitor);

    public abstract Set<EdgeInfo<V, E>> mst();

    public abstract List<V> topologicalSort();

    //	public abstract Map<V, E> shortestPath(V begin);
    public abstract Map<V, PathInfo<V, E>> shortestPath(V begin);

    public abstract Map<V, Map<V, PathInfo<V, E>>> shortestPath();

    public interface WeightManager<E> {
        int compare(E w1, E w2);
        E add(E w1, E w2);
        E zero();
    }

    public interface VertexVisitor<V> {
        boolean visit(V v);
    }

    public static class PathInfo<V, E> {
        protected E weight;
        protected List<EdgeInfo<V, E>> edgeInfos = new LinkedList<>();
        public PathInfo() {}
        public PathInfo(E weight) {
            this.weight = weight;
        }
        public E getWeight() {
            return weight;
        }
        public void setWeight(E weight) {
            this.weight = weight;
        }
        public List<EdgeInfo<V, E>> getEdgeInfos() {
            return edgeInfos;
        }
        public void setEdgeInfos(List<EdgeInfo<V, E>> edgeInfos) {
            this.edgeInfos = edgeInfos;
        }
        @Override
        public String toString() {
            return "PathInfo [weight=" + weight + ", edgeInfos=" + edgeInfos + "]";
        }
    }

    public static class EdgeInfo<V, E> {
        private V from;
        private V to;
        private E weight;
        public EdgeInfo(V from, V to, E weight) {
            this.from = from;
            this.to = to;
            this.weight = weight;
        }
        public V getFrom() {
            return from;
        }
        public void setFrom(V from) {
            this.from = from;
        }
        public V getTo() {
            return to;
        }
        public void setTo(V to) {
            this.to = to;
        }
        public E getWeight() {
            return weight;
        }
        public void setWeight(E weight) {
            this.weight = weight;
        }
        @Override
        public String toString() {
            return "EdgeInfo [from=" + from + ", to=" + to + ", weight=" + weight + "]";
        }
    }
}
