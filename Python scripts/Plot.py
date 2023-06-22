import matplotlib.pyplot as plt

# List of control names and ASS values
controls = ['NS-1', 'NS-3', 'NS-4_OnSpoke', 'NS-4_OnAsset', 'NS-6' ,'NS-7', 'NS-8']
avs_values = [1.09, 3.45, 3.45, 0, 0,1.09, 0]

# Create the line plot
plt.plot(controls, avs_values, marker='o')

# Set plot title and labels
plt.xlabel('Controls')
plt.ylabel('Adjusted Vulnerability Score')
plt.title('Adjusted Vulnerability Score per Control')

plt.show()
