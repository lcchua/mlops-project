### Prometheus & Grafana SRE Monitoring Tools
This repository contains the setup and configuration for Prometheus and Grafana monitoring tools, designed to monitor and visualize the key performance signals for system and application health. The monitoring setup adheres to Site Reliability Engineering (SRE) best practices, specifically focusing on the SRE 4 Golden Signals: 

![image](https://github.com/user-attachments/assets/cdead711-a757-4277-8c0d-1714588aae81)
 

#### **Dependencies** 
This repository requires the following dependencies to be set up:
- Prometheus for metrics collection and monitoring.
- Grafana for data visualization and dashboard creation.
- Node Exporter for system-level metrics (CPU, memory, disk, network, file system).
- Loki (for log aggregation and query in Grafana).

#### **Installation** 
1. Ensure **Helm** is installed. If not, install Helm following the instructions [here](https://helm.sh/docs/intro/install/)

2. Install Prometheus Helm chart:
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus
```

3. Install Grafana Helm Chart:
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana
```

4. Install Loki stack for log aggregation:
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install loki grafana/loki-stack
```

#### Creating a Grafana Dashboard from Scratch and Linking Data Sources
In this project, Grafana, Prometheus, and Loki were initially installed on a local machine while awaiting the finalisation of the workflow for the capstone project's EKS cluster. A custom Grafana dashboard was created for set up and testing purposes. Once the group's capstone EKS cluster was ready, the dashboard configuration was saved as a JSON file and uploaded to the cluster.

To create a dashboard on Grafana localhost from scratch. Follow these steps:

1. Access Grafana
Open your browser and go to Grafana’s web interface, typically available at
```bash http://localhost:3000```

2. The default login credentials are:

- Username: ```bash admin```
- Password: ```bash admin (or prom-operator)```

3. Add Prometheus and Loki Data Sources
Before creating the dashboard, ensure that Prometheus and Loki are added as data sources:
Home
  -->Connections
      -->Data sources

![image](https://github.com/user-attachments/assets/d3c180f1-7414-4846-8057-fb62b66a7683)

![image](https://github.com/user-attachments/assets/68679692-e380-4551-9816-746f1efb827c)

  **_Add Prometheus as a Data Source:_**
- In the Grafana dashboard, click on the gear icon (⚙️) on the left sidebar to go to **Configuration**
- Under **Data Sources**, click **Add data source**
- Select **Prometheus** from the list of data sources.
- In the URL field, enter the URL of your Prometheus instance (e.g., http://localhost:9090).
- Click **Save & Test** to ensure the data source is connected.

  _**Add Loki as a Data Source:**_
- Under **Configuration**, click **Add data source** again.
- Select **Loki **from the list of data sources.
- In the **URL** field, enter the URL of the Loki instance (e.g., http://localhost:3100).
- Click **Save & Test** to ensure the data source is connected.

4. Create a Dashboard from Scratch
- In the left sidebar, click the + icon and select **Dashboard**.
- This will create a new empty dashboard.
- Click on **Add Panel** to start adding the visualization.
- In the Query section, select** Prometheus** for metrics or **Loki **for logs.

5. Saving the Dashboard
- After making changes and finalizing your dashboard, click on the **"Save dashboard"** button located at the top right corner of the dashboard.
Enter a name for the dashboard and click "Save" to store the dashboard configuration.
![image](https://github.com/user-attachments/assets/f68eed71-aba6-4cae-9312-38335116d2ea)

6. Download the JSON File:
- To download the dashboard as a JSON file, click the **"Share" **button at the top of the dashboard.
![image](https://github.com/user-attachments/assets/3b202ffc-a59e-4ba1-8178-6ee1494a11d3)

- In the window that appears, select the **"Export"** tab and click the **"Save to file"** button.
![image](https://github.com/user-attachments/assets/32407c62-697d-4936-89b8-a57c6ad1128a)

- This will download the dashboard’s configuration as a JSON file to your computer.

7. Uploading the JSON File to EKS Cluster
- Once the EKS cluster is ready, the saved JSON file is imported to the EKS's grafana with configuration.
- Navigate to the Grafana dashboard running on the EKS cluster. If access is via Load Balancer, open the Grafana URL in the browser.
- In the Grafana UI, click the "+" icon on the left sidebar and select "Import".
- In the "Import Dashboard" section, click the "Upload JSON file" button.
- Browse to the location where you downloaded the JSON file and select it.

#### Reliability Engineering (SRE)
This section breaks down the key metrics based on the SRE 4 Golden Signals framework. These signals help monitor the system health and performance.

**Key Metrics:**
_**1. Saturation (Resource Utilisation)**_
Saturation measures the system's capacity and how full the resources are (CPU, memory, disk, etc.)

_**•	CPU Utilisation**_
The query calculates the CPU usage percentage by subtracting the idle CPU time (as a percentage) from 100, using the irate function to measure the rate of change of idle time over the last 5 minutes. If utilisation is above 85% utilization often indicates the CPU is nearing saturation and may cause: 
a) Slow response times.
b) Queuing delays for processes.
c) Application timeouts.

- Data Source: Prometheus
- ```100 - (avg by (instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) ```

![image](https://github.com/user-attachments/assets/cd62a32d-daf1-4e3b-a42b-6ad3cdee6de2)

_**•	Memory Utilisation**_
- This query calculates the percentage of used memory by subtracting available memory from total memory and then dividing by the total memory, multiplied by 100. Similar to CPU Utilisation, anything above Above 85% utilization often indicates the memory is nearing saturation.
  
- Data Source: Prometheus
- ```(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100```

![image](https://github.com/user-attachments/assets/57462672-7c87-41ad-9948-8d92532fed43)

•	**Disk Saturation**
- High disk read/write activity might indicate heavy workloads or bottlenecks.
- This This query calculates the rate of disk read and write bytes over the last 5 minutes.
- Data Source: Promethues
- ```rate(node_disk_read_bytes_total[5m])```

![image](https://github.com/user-attachments/assets/27b3bc1b-a4b2-408a-8051-8be11c7706f0)

•	_**2. Traffic (Request Volume)**_
- Traffic measures the load on the system, whether it is operating within expected capacity. This is vital for understanding demand and identifying potential overloading.


•	**Network Throughput (Incoming and Outgoing Traffic)**
- This command calculates the rate of network bytes received over the last 5 minutes.
- Sudden spikes in incoming or outgoing traffic may signify potential attacks or high usage.
- Data Source: Prometheus
- Incoming ```rate(node_network_transmit_bytes_total[5m])```
- Outgoing ```rate(node_network_transmit_bytes_total[5m])```

![image](https://github.com/user-attachments/assets/87d58c4d-63d7-44d8-9e58-e50f7ebedc9e)

•	_**3. Error (Request Volume)**
- Tracks the rate or number of times requests to application fails.

•	**HTTP Error (4xx - Client) (5xx - Server)**
- This query counts occurrences of "statusCode=4" (Client Error) and "statusCode=5" (Server Error) in the "monitoring" namespace over the last 5 minutes.
- High error count can point to client issues (4xx)
- Data Source: Loki
-  ``` count_over_time({namespace="monitoring"} |= "statusCode=4" [5m])```
-  ``` count_over_time({namespace="monitoring"} |= "statusCode=5" [5m])```

![image](https://github.com/user-attachments/assets/a5fd29a3-01b2-4550-a47b-cdc43f5ea22f)

•	**Logs for HTTP Error (4xx - Client) (5xx - Server)**
- This query provides the logs for review.
- Data Source: Loki
-  ``` {namespace="monitoring"} |~ "statusCode=(4[0-9]{2})"``` 
-  ``` {namespace="monitoring"} |~ "statusCode=(5[0-9]{2})"```

![image](https://github.com/user-attachments/assets/b7ca27f1-0b4a-43a8-842d-0909401570cc)

•	_**4. Latency**
-  Latency measures the time it takes for a request or transaction to complete. This is important for both system and application performance.

•	**HTTP Response Latency**
- This query calculates the average HTTP request duration for the Prometheus job ce7-grp-1-prome-kube-prome-prometheus in the "monitoring" namespace over the last 5 minutes.
- Ideally we want this to be constant (i.e. flat).Increased latency indicates potential application or backend bottlenecks
- Data Source: Prometheus
-  ```sum(rate(prometheus_http_request_duration_seconds_sum{namespace="monitoring", job="ce7-grp-1-prome-kube-prome-prometheus"}[5m]))
/
sum(rate(prometheus_http_request_duration_seconds_count{namespace="monitoring",job="ce7-grp-1-prome-kube-prome-prometheus"}[5m]))```

![image](https://github.com/user-attachments/assets/f7134e64-1ba7-4981-9b7e-6c1b34601418)

#### Learning Journey

**Understanding Metrics**
- To create useful dashboards, I need to understand what the metrics mean, how they are calculated, and how they impact system health.
For example, knowing the 4 Golden Signals (saturation, traffic, errors, and latency) helps to create meaningful queries and good visualizations.
Mathematical Insight:

- It is important to understand the formulas behind metrics like request duration or CPU usage to properly analyze system behavior. However, this can be difficult, and there aren’t many helpful resources online.

**Using Different Tools**
- Prometheus, Grafana, and Loki work together to provide full system visibility, making it important to use them together for better monitoring.

**Team Collaboration**
- Working with the team is key. Without my team mate help, I wouldn’t have been able to get started. 
