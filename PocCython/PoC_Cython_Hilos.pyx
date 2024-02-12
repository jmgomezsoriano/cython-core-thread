# Código Prueba de Concepto Cython con Hilos

cimport cython
from threading import Thread
import time
import math
import psutil  

# Función de cálculo
@cython.boundscheck(False)
@cython.wraparound(False)
cpdef calculo(list input_list):

    # Se inicializan los 2 hilos con identificadores
    t1 = Thread(target=procesado, args=(input_list, 1))
    t2 = Thread(target=procesado, args=(input_list, 2))

    # Se inician las tareas
    t1.start()
    t2.start()

    # Se espera a que termine la ejecución de los dos hilos
    t1.join()
    t2.join()

    # Se juntan los resultados de los hilos
    result = input_list

    return result

# Función de procesamiento
@cython.boundscheck(False)
@cython.wraparound(False)
cpdef procesado(list input_list, int thread_id):
    start_time = time.time()

    # Obtener el identificador del núcleo
    core_id = obtener_identificador_nucleo()

    # Se realiza la operación seleccionada en la parte de la lista correspondiente
    for i in range(len(input_list)):
        if i % 2 != 0 and thread_id == 1:
            input_list[i-1] = math.factorial(i)
        elif i % 2 == 0 and thread_id == 2:
            input_list[i-1] = math.factorial(i)

    end_time = time.time()
    execution_time = end_time - start_time
    
    print(f"\nTiempo de ejecución del hilo {thread_id} en el núcleo {core_id}: {execution_time} segundos")

# Función de cálculo del factorial
@cython.boundscheck(False)
@cython.wraparound(False)
cpdef factorial(int x):
    return math.factorial(x)

# Función para obtener el identificador del núcleo
def obtener_identificador_nucleo():
    pid = psutil.Process().pid
    try:
        info_proceso = psutil.Process(pid)
        identificador_nucleo = info_proceso.cpu_affinity()[0]
        return identificador_nucleo
    except psutil.NoSuchProcess as e:
        print(f"Error: {e}")
        return None
