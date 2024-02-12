# Código Prueba de Concepto Cython con Procesos

cimport cython
from libc.stdlib cimport malloc, free
from threading import Thread
import time
import math
import psutil
from multiprocessing import Process, Queue
import win32process

# Función de cálculo
@cython.boundscheck(False)
@cython.wraparound(False)
cpdef calculo(list input_list):

    q = Queue()
    # Se inicializan los 2 hilos con identificadores
    p1 = Process(target=procesado, args=(input_list, 1, q))
    p2 = Process(target=procesado, args=(input_list, 2, q))

    # Se asigna un core diferente a cada proceso
    current_process = win32process.GetCurrentProcess()
    win32process.SetProcessAffinityMask(current_process, 1)
    p1.start()
    
    win32process.SetProcessAffinityMask(current_process, 2)
    p2.start()

    p1.join()
    p2.join()

    result = []
    for _ in range(2):
        result.extend(q.get())

    q.close()  # Se cierra la cola de procesos
    
    return result

# Función de procesamiento
@cython.boundscheck(False)
@cython.wraparound(False)
cpdef procesado(list input_list, int process_id, queue):
    start_time = time.time()

    # Obtener el identificador del núcleo
    core_id = obtener_identificador_nucleo()

    sublist = []
    # Se realiza la operación seleccionada en la parte de la lista correspondiente
    for i in range(len(input_list)):
        if i % 2 != 0 and process_id == 1:
            sublist.append(math.factorial(i))
        elif i % 2 == 0 and process_id == 2:
            sublist.append(math.factorial(i))

    queue.put(sublist)

    end_time = time.time()
    execution_time = end_time - start_time

    print(f"\nExecution time of process {process_id} on core {core_id}: {execution_time} seconds")

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
