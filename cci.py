import subprocess
import sys
import os

def run_command(command):
    """Run a shell command and check for errors."""
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

    # Set directories
    algoritmoIN_dir = "algoritmoIN"
    base_prueba_dir = "Base_Prueba"

    # Step 1: Compile and run corp.pas for cropping
    print("Compiling and running corp.pas...")
    run_command(f"fpc {algoritmoIN_dir}/corp.pas")
    run_command(f"{algoritmoIN_dir}/corp {input_file}" if os.name != "nt" else f"{algoritmoIN_dir}\\corp.exe {input_file}")

    # Step 2: Run Python transparency script
    print("Running Python transparency script...")
    run_command(f"python3 {algoritmoIN_dir}\\corp.py" if os.name != "nt" else f"py {algoritmoIN_dir}\\corp.py")

    # Step 3: Compile and run algoritmo.pas for cloud coverage calculation
    print("Compiling and running algoritmo.pas...")
    run_command(f"fpc {algoritmoIN_dir}/algoritmo.pas")
    run_command(f"{algoritmoIN_dir}/algoritmo" if os.name != "nt" else f"{algoritmoIN_dir}\\algoritmo.exe")

    # Step 4: Compile and run DetectorImagen.pas in Base Prueba
    print("Compiling and running DetectorImagen.pas for black and white output...")
    run_command(f"fpc {base_prueba_dir}/DetectorImagen.pas")
    if segmentation_flag and segmentation_flag.lower() == 's':
        run_command(f"{base_prueba_dir}/DetectorImagen {input_file}" if os.name != "nt" else f"{base_prueba_dir}\\DetectorImagen.exe {input_file}")

if __name__ == "__main__":
    main()
