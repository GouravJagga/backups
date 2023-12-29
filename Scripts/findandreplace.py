import sys

def find_replace(file_path, old_text, new_text):
    with open(file_path, 'r') as file:
        filedata = file.read()

    # Perform the replacement
    new_filedata = filedata.replace(old_text, new_text)
    print(new_filedata)
    with open(file_path, 'w') as file:
        file.write(new_filedata)

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script_name.py file_path old_text new_text")
    else:
        file_path = sys.argv[1]
        old_text = sys.argv[2]
        new_text = sys.argv[3]
        print(old_text+" "+new_text)
        find_replace(file_path, old_text, new_text)
