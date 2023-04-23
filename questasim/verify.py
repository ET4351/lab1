import os

def compare_files(file1, file2):
    file1_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), file1)
    file2_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), file2)
    with open(file1_path, 'r') as f1, open(file2_path, 'r') as f2:
        return f1.read() == f2.read()

file1 = 'outputs.txt'
file2 = 'task3_gold.txt'

if compare_files(file1, file2):
    print("Test Passed ^_^ Outputs and Gold are identical!!!")
else:
    print("Test Failed -_- Outputs and Gold are different...")
