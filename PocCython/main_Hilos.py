# Código Python para ejecución de Hilos con memoria compartida (mismo core)

from PoC_Cython_Hilos import calculo

# Initialize your list with 7000 elements
my_list = list(range(1, 7001))
print('\nFirst values of the original list:\n', my_list[:5])

# Call the Cython function to perform factorial calculation
result = calculo(my_list)

# Print or use the result as needed
print('\nFirst values of the processed list:\n', result[:5], '\n')
