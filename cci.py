import subprocess
import sys
import os

def run_command(command):
    """
    Función que ejecuta un comando del sistema si falla termina el programa.

    Args:
        command (string): El comando que se va a ejecutar.
    """
    result = subprocess.run(command, shell=True)
    if result.returncode != 0:
        print(f"Error al ejecutar el programa: {' '.join(command)}")
        sys.exit(1)

def get_python_command():
    """
    Función que intenta detectar el comando del sistema para ejecutar los elementos de python.

    Return:
        str: El comando que usa tu sistema para inicializar Python.
    
    Raises:
        EnviromentError: Si no se encuentra el comando adecuado.
    """
    commands = ['python3', 'python', 'py'] #Si este listado no es suficiente, favor de añadir el de su sistema.
    for command in commands:
        try:
            result = subprocess.run([command, '--version'], stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
            if result.returncode == 0:
                return command
        except FileNotFoundError:
            continue
    raise EnvironmentError("No se pudo encontrar un comando adecuado para iniciar Python.")

def main():
    """
    Función principal que coordina la ejecución de los programas necesarios. 
    Se requiere un archivo imagen como argumento y una bandera opcional 'S' para convertir a blanco y negro.

    Ejemplos de uso:
        python cci.py El nombre del archivo de la imagen. S
        python cci.py El nombre del archivo de la imagen. s
    
    Args:
        sys.argv[1] (String): El nombre del archivo de la ímagen.
        sys.argv[2] (String, opcional): La bandera de segmentación s o S.
    
    Raises:
        SystemExit: Si no se proporciona al menos un argumento.
    """
    if len(sys.argv) < 2:
        print("Uso: python cci.py <archivo_imagen.jpg> [S] o python3 cci.py <archivo_imagen.jpg> [s] ")
        sys.exit(1)
    input_file = sys.argv[1]
    segmentation_flag = sys.argv[2] if len(sys.argv) > 2 else None
    algoritmoIN_dir = "algoritmoIN"
    base_prueba_dir = "Base_Prueba"
    
    python_command = get_python_command()
    
    print("Compilando y corriendo corp.pas...")
    run_command(f"fpc {algoritmoIN_dir}/corp.pas")
    run_command(f"{algoritmoIN_dir}/corp {base_prueba_dir}/IMG/{input_file}" if os.name != "nt" else f"{algoritmoIN_dir}\\corp.exe {base_prueba_dir}\\IMG\\{input_file}")
    
    print("Compilando y corriendo corp.py...")
    run_command(f"{python_command} {algoritmoIN_dir}/corp.py" if os.name != "nt" else f"{python_command} {algoritmoIN_dir}\\corp.py")
    
    print("Compilando y corriendo algoritmo.pas...")
    run_command(f"fpc {algoritmoIN_dir}/algoritmo.pas")
    run_command(f"{algoritmoIN_dir}/algoritmo" if os.name != "nt" else f"{algoritmoIN_dir}\\algoritmo.exe")
    
    print("Compilando y ejecutando DetectorImagen.pas para convertir a blanco y negro...")
    run_command(f"fpc {base_prueba_dir}/DetectorImagen.pas")
    
    if segmentation_flag and segmentation_flag.lower() == 's':
        run_command(f"{base_prueba_dir}/DetectorImagen {input_file}" if os.name != "nt" else f"{base_prueba_dir}\\DetectorImagen.exe {input_file}")

if __name__ == "__main__":
    main()
