import multiprocessing

class Graph:
    def __init__(self, num_vertices):
        self.num_vertices = num_vertices
        self.vertices = multiprocessing.Array('i', [0] * (num_vertices * num_vertices))
        self.lock = multiprocessing.Lock()

    def añadir_arista(self, vertice_origen, vertice_destino):
        with self.lock:
            self.vertices[vertice_origen * self.num_vertices + vertice_destino] = 1
            self.vertices[vertice_destino * self.num_vertices + vertice_origen] = 1

    def obtener_vertices(self):
        with self.lock:
            return list(range(self.num_vertices))

    def obtener_aristas(self):
        with self.lock:
            aristas = []
            for i in range(self.num_vertices):
                for j in range(self.num_vertices):
                    if self.vertices[i * self.num_vertices + j] == 1:
                        aristas.append((i, j))
            return aristas

def proceso(grafo, operaciones):
    for operacion in operaciones:
        if operacion[0] == 'añadir_vertice':
            grafo.añadir_vertice()
        elif operacion[0] == 'añadir_arista':
            grafo.añadir_arista(operacion[1], operacion[2])
        elif operacion[0] == 'obtener_vertices':
            print("Vertices:", grafo.obtener_vertices())
        elif operacion[0] == 'obtener_aristas':
            print("Aristas:", grafo.obtener_aristas())

if __name__ == "__main__":
    num_vertices = 5  # Define el número de vértices en tu grafo
    grafo_inicial = Graph(num_vertices)
    
    # Printeamos el grafo inicial
    print("Vértices iniciales del grafo:", grafo_inicial.obtener_vertices())
    print("Aristas iniciales del grafo:", grafo_inicial.obtener_aristas(), "\n")
    
    # Crear procesos
    num_procesos = multiprocessing.cpu_count()
    procesos = []
    for _ in range(num_procesos):
        p = multiprocessing.Process(target=proceso, args=(grafo_inicial, [('añadir_arista', 0, 1), ('añadir_arista', 1, 2)]))
        procesos.append(p)
        p.start()

    # Esperar a que los procesos terminen
    for p in procesos:
        p.join()

    # Imprimir vértices final
    print("Vértices final:", grafo_inicial.obtener_vertices())
    # Imprimir aristas final
    print("Aristas final:", grafo_inicial.obtener_aristas())
