import subprocess
import sys
import os

def run_command(command):
    """
    Función que ejecuta un comando del sistema y termina el programa si falla.

    Args:
        command (str): El comando del sistema que se va a ejecutar.
    """
    result = subprocess.run(command, shell=True)
    if result.returncode != 0:
        print(f"Error al ejecutar el programa: {' '.join(command)}")
        sys.exit(1)

def get_python_command():
    """
    Función que intenta detectar el comando adecuado para iniciar Python.

    Returns:
        str: El comando adecuado para iniciar Python (`python3`, `python`, o `py`).
    
    Raises:
        EnvironmentError: Si no se encuentra un comando adecuado.
    """
    commands = ['python3', 'python', 'py']
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
    Requiere un archivo de imagen como argumento y una bandera opcional 'S' para convertir a blanco y negro.

    Ejemplos de uso:
        python run_all.py <archivo_imagen.jpg> [S]
    
    Args:
        sys.argv[1] (str): El nombre del archivo de imagen.
        sys.argv[2] (str, opcional): La bandera de segmentación (`S` o `s`).
    
    Raises:
        SystemExit: Si no se proporciona al menos un argumento.
    """
    if len(sys.argv) < 2:
        print("Uso: python run_all.py <archivo_imagen.jpg> [S]")
        sys.exit(1)
    input_file = sys.argv[1]
    segmentation_flag = sys.argv[2] if len(sys.argv) > 2 else None
    
    python_command = get_python_command()
    
    # Directorios de los programas
    python_dir = "Python"
    pascal_dir = "Pascal"
    
    print("Compilando y ejecutando algoritmoIN.pas...")
    run_command(f"fpc {pascal_dir}/algoritmoIN.pas")
    run_command(f"{pascal_dir}/algoritmoIN {pascal_dir}/{input_file}" if os.name != "nt" else f"{pascal_dir}\\algoritmoIN.exe {pascal_dir}\\{input_file}")
    
    print("Compilando y ejecutando recortar.pas...")
    run_command(f"fpc {pascal_dir}/recortar.pas")
    run_command(f"{pascal_dir}/recortar {pascal_dir}/{input_file}" if os.name != "nt" else f"{pascal_dir}\\recortar.exe {pascal_dir}\\{input_file}")

    print("Ejecutando algoritmoIN.py...")
    run_command(f"{python_command} {python_dir}/algoritmoIN.py {python_dir}/{input_file}" if os.name != "nt" else f"{python_command} {python_dir}\\algoritmoIN.py {python_dir}\\{input_file}")
    
    print("Ejecutando recortar.py...")
    run_command(f"{python_command} {python_dir}/recortar.py {python_dir}/{input_file}" if os.name != "nt" else f"{python_command} {python_dir}\\recortar.py {python_dir}\\{input_file}")

if __name__ == "__main__":
    main()
