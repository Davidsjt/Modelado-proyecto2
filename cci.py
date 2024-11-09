import subprocess
import sys
import os

def run_command(command):
    result = subprocess.run(command, shell=True)
    if result.returncode != 0:
        print(f"Error running command: {' '.join(command)}")
        sys.exit(1)

def main():
    if len(sys.argv) < 2:
        print("Usage: py script.py <image_file.jpg> [S]")
        sys.exit(1)
    input_file = sys.argv[1]
    segmentation_flag = sys.argv[2] if len(sys.argv) > 2 else None
    algoritmoIN_dir = "algoritmoIN"
    base_prueba_dir = "Base_Prueba"
    print("Compilando y corriendo corp.pas...")
    run_command(f"fpc {algoritmoIN_dir}/corp.pas")
    run_command(f"{algoritmoIN_dir}/corp {input_file}" if os.name != "nt" else f"{algoritmoIN_dir}\\corp.exe {input_file}")
    print("Compilando y corriendo corp.py...")
    run_command(f"python3 {algoritmoIN_dir}\\corp.py" if os.name != "nt" else f"py {algoritmoIN_dir}\\corp.py")
    print("Compilando y corriendo algoritmo.pas...")
    run_command(f"fpc {algoritmoIN_dir}/algoritmo.pas")
    run_command(f"{algoritmoIN_dir}/algoritmo" if os.name != "nt" else f"{algoritmoIN_dir}\\algoritmo.exe")
    print("Compilando y ejecutando DetectorImagen.pas para convertir a blanco y negro...")
    run_command(f"fpc {base_prueba_dir}/DetectorImagen.pas")
    if segmentation_flag and segmentation_flag.lower() == 's':
        run_command(f"{base_prueba_dir}/DetectorImagen {input_file}" if os.name != "nt" else f"{base_prueba_dir}\\DetectorImagen.exe {input_file}")

if __name__ == "__main__":
    main()
