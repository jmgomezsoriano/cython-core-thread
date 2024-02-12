from multiprocessing import Array, Process
import multiprocessing
import time

def mi_proceso(core, arr):
    arr[core] += 1

if __name__ == '__main__':
    # Obtener el número de CPU disponibles
    num_cores = multiprocessing.cpu_count()
    
    resultado = Array('i', [0] * num_cores)

    # Crear una lista de procesos
    procesos = []
    start_time = time.time()
    
    # Crear y arrancar un proceso por cada núcleo
    for i in range(num_cores):
        proceso = Process(target=mi_proceso, args=(i, resultado))
        procesos.append(proceso)
        proceso.start()

    # Esperar a que todos los procesos terminen
    for proceso in procesos:
        proceso.join()
        
    # Tiempo de finalización
    end_time = time.time()

    # Calcular el tiempo total de ejecución
    total_time = end_time - start_time
    print(f'Tiempo total de ejecución de los procesos: {total_time} segundos con el resultado {resultado[:]}')