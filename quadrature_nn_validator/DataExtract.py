import skrf as rf
import numpy as np
import re

# TODO
# Search for the accepted values for the S parameters to be considered accepted or not
# Add a function to check if the S parameters are acceptable or not

def main():
   lambdasweep = get_Param_data("lambdasweep", "RF_Project")
   Z0root2sweep = get_Param_data("Z0root2sweep", "RF_Project")
   Z0sweep_part1 = get_Param_data("Z0sweep_part1", "RF_Project")
   Z0sweep_part2 = get_Param_data("Z0sweep_part2", "RF_Project")
   Z0sweep = np.concatenate((Z0sweep_part1, Z0sweep_part2), axis=1)
   np.save("lambdasweep.npy", lambdasweep)
   np.save("Z0root2sweep.npy", Z0root2sweep)
   np.save("Z0sweep.npy", Z0sweep)

def get_Param_data(folder, file):
    freq_target = 4e9  # 4 GHz
    sparam_list = []   # Each entry is a column (file) → 16 S-params
    i = 1              # File index counter
    print("Starting to load files...")
    

    while True:
        try:
            filename = fr"resources\{folder}\{file}_{i}.s4p"
            ntw = rf.Network(filename)

            # Check if 4 GHz exists in frequency list
            if freq_target not in ntw.f:
                print(f"4 GHz not found in {filename}. Skipping.")
                i += 1
                continue

            s_vector = get_sparams_at_freq(ntw, freq_target)  # shape (16,)
            sparam_list.append(s_vector) # add the vector as a row to the list
            print(f"Loaded S-parameters from: {filename}")

            i += 1  # Move to next file
        except FileNotFoundError:
            print(f"No more files after RF_Project_{i-1}.s4p. Ending loop.")
            break
        except Exception as e:
            print(f"Error reading {filename}: {e}")
            i += 1  # Skip to next file anyway
    # NOTE: sparam_list shape is still m rows of s_vector (16,)
    # Assemble final array: shape (16, m)
    if sparam_list:
        sparam_matrix = np.array(sparam_list).T  # Transpose to (16, m)
        print(f"\nFinal matrix shape: {sparam_matrix.shape}")
        # # print(sparam_matrix)
        # print("S-parameters for first example:")
        # print(sparam_matrix[:,0])
    else:
        print("No valid files found.")

    return sparam_matrix  # Return the final matrix of S-parameters



# Extracts S-parameters at the target frequency from the network object    
def get_sparams_at_freq(ntw, freq):
    """Extracts all 16 S-parameters at the target frequency as a flat list."""
    index = np.where(ntw.f == freq)[0][0]
    s_matrix = ntw.s_mag[index, :, :]  # shape: (4, 4)
    return s_matrix.flatten()  # row-major: [s11, s12, ..., s44] 





# Gives a dictionary of parameters from the touchstone file which can be used to identify Z0, L, W, etc.
def extract_params_from_touchstone(filename):
    with open(filename, 'r') as file:
        for line in file:
            if line.startswith('! Parameters'):
                # Example line:
                # ! Parameters = {H=1.5; L=50; W=50; Z0=2.94; Z0root2=5; lamda=46}
                match = re.search(r'\{(.+?)\}', line)
                if match:
                    # Extract the parameters inside the braces
                    param_str = match.group(1)
                    # Split the parameters by semicolon
                    param_pairs = param_str.split(';')
                    param_dict = {}
                    for pair in param_pairs:
                        if '=' in pair:
                            # Split by '=' and strip whitespace
                            key, value = pair.split('=')
                            param_dict[key.strip()] = float(value.strip())
                    return param_dict
    return {}  # Return empty if not found




if __name__ == "__main__":
    main()