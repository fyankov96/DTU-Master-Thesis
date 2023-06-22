import networkx as nx
import matplotlib.pyplot as plt

# Create an empty graph
G = nx.Graph()

# Add nodes for all the VMs and subnets with user-friendly names
nodes = {
    "Spoke1_Subnet1": "Spoke1 Subnet1",
    "Vuln-Win2008-VM": "Vulnerable Win2008 VM",
    "Compromised-Linux-VM": "Compromised Linux VM",
    "StorageAccount_Private_Endpoint": "Storage Account Private Endpoint",
    "Spoke1_NSG": "Spoke1 NSG",
    "Spoke2_Subnet1": "Spoke2 Subnet",
    "Spoke2_NSG": "Spoke2 NSG",
    "Spoke_1": "Spoke 1",
    "Spoke_2": "Spoke 2",
    "Hub": "Hub",
}

for node in nodes.keys():
    G.add_node(node)

# Add edges to represent connections
G.add_edge("Spoke_1", "Spoke1_Subnet1")
G.add_edge("Spoke1_Subnet1", "StorageAccount_Private_Endpoint")
G.add_edge("Spoke1_Subnet1", "Spoke1_NSG")
G.add_edge("Spoke_1", "Hub")
G.add_edge("Spoke2_Subnet1", "Compromised-Linux-VM")
G.add_edge("Spoke2_Subnet1", "Spoke2_NSG")
G.add_edge("Spoke_2", "Spoke2_Subnet1")
G.add_edge("Spoke_2", "Hub")



# Customize node colors and sizes based on their type
node_colors = []
node_sizes = []
for node in G.nodes():
    if "Subnet" in node:
        node_colors.append("lightblue")
        node_sizes.append(500)
    elif "NSG" in node:
        node_colors.append("blue")
        node_sizes.append(600)
    elif "Hub" in node or "Spoke_1" in node or "Spoke_2" in node:
        node_colors.append("purple")
        node_sizes.append(700)
    elif "Vuln-Win2008-VM" in node:
        node_colors.append("red")
        node_sizes.append(300)
    elif "WAF" in node:
        node_colors.append("orange")
        node_sizes.append(800)
    else:
        node_colors.append("green")
        node_sizes.append(300)

# Find and print the connected components of the graph
connected_components = list(nx.connected_components(G))
for i, component in enumerate(connected_components, start=1):
    print(f"Connected component {i}: {component}")

# Use BFS to color all the nodes that can be reached from "Vuln-Win2008-VM" in red, except NSGs
for node in nx.bfs_tree(G, "Vuln-Win2008-VM"):
    if "NSG" not in node and "Hub" not in node and "IDPS" not in node and "WAF" not in node:
        node_colors[list(G.nodes()).index(node)] = "red"



# Draw the graph with custom node colors and sizes
pos = nx.spring_layout(G)  # positions for all nodes
nx.draw(G, pos, with_labels=False, node_size=node_sizes, node_color=node_colors)  # nodes
label_pos = {key: (value[0], value[1] - 0.05) for key, value in pos.items()}
nx.draw_networkx_labels(G, label_pos, labels=nodes)  # labels
plt.show()



# Define all vertices included in the calculation
ces_vertices = ['Spoke_2', 'StorageAccount_Private_Endpoint', 'Compromised-Linux-VM', 
                'Spoke2_Subnet1', 'Spoke_1', 'Hub', 'Spoke1_Subnet1', 'Vuln-Win2008-VM', 
               ]

# Find the reachable nodes from 'Compromised-Linux-VM'
reachable_nodes = nx.descendants(G, "Vuln-Win2008-VM")

# Filter reachable_nodes to include only those in ces_vertices
reachable_nodes = [node for node in reachable_nodes if node in ces_vertices]

print(reachable_nodes)

# Define the ideal scenario: only 'Vuln-Win2008-VM' is reachable
ideal_scenario = ['Vuln-Win2008-VM']

# Calculate the Control Effectiveness Score (CES)
if len(reachable_nodes) == len(ces_vertices):
    ces = 0
elif reachable_nodes == ideal_scenario:
    ces = 1
else:
    # For situations in between, calculate the proportion of unreachable vertices
    ces = 1 - len(reachable_nodes) / len(ces_vertices)

print("Control Effectiveness Score (CES):", ces)


