## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![](https://github.com/shadowlockie1/shadowlockie1/blob/main/Images/Diagram.png)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the playbook file may be used to install only certain pieces of it, such as Filebeat.

  PLAYBOOK 1 PENTEST.YML
```
---
- name: Config Web VM with Docker
hosts: webservers
become: true
tasks:

  - name: Install docker.io
    apt:
      update_cache: yes
      name: docker.io
      state: present

  - name: Install pip3
    apt:
      name: python3-pip
      state: present

  - name: Install python Docker Module
    pip:
      name: docker
      state: present

  - name: Download and launch a docker web container
    docker_container:
      name: dvwa
      image: cyberxsecurity/dvwa
      state: started
      restart_policy: always
      published_ports: 80:80

  - name: Enable Docker Service
    systemd:
      name: docker
      enabled: yes
```      

This document contains the following details:
- Description of the Topologu
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored
- How to Use the Ansible Build

PLAYBOOK 2 INSTALL-ELK.YML
```
---
- name: Configure Elk VM with Docker
hosts: elk
remote_user: azadmin
become: true
tasks:

  - name: Install docker.io
    apt:
      update_cache: yes
      force_apt_get: yes
      name: docker.io
      state: present

  - name: Install pip3
    apt:
      force_apt_get: yes
      name: python3-pip
      state: present

  - name: Install Docker module
    pip:
      name: docker
      state: present

  - name: Increase virtual memory
    command: sysctl -w vm.max_map_count=262144

  - name: Use more memory
    sysctl:
      name: vm.max_map_count
      value: '262144'
      state: present
      reload: yes

  - name: download and launch a docker elk container
    docker_container:
      name: elk
      image: sebp/elk:761
      state: started
      restart_policy: always
      published_ports:
        -  5601:5601
        -  9200:9200
        -  5044:5044
```

PLAYBOOK 3 FILEBEAT-PLAYBOOK.YML
```
---
- name: installing and launching filebeat
hosts: webservers
become: yes
tasks:

- name: download filebeat deb
  command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.6.1-amd64.deb

- name: install filebeat deb
  command: dpkg -i filebeat-7.6.1-amd64.deb

- name: drop in filebeat.yml
  copy:
    src: /etc/ansible/filebeat-config.yml
    dest: /etc/filebeat/filebeat.yml

- name: enable and configure system module
  command: filebeat modules enable system

- name: setup filebeat
  command: filebeat setup

- name: start filebeat service
  command: service filebeat start

- name: enable service filebeat on boot
  systemd:
    name: filebeat
    enabled: yes
```

PLAYBOOK 4 METRICBEAT-PLAYBOOK.YML
```
- name: Install metric beat
hosts: webservers
become: true
tasks:

- name: Download metricbeat
  command: curl -L -O curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.6.1-amd64.deb

- name: install metricbeat
  command: dpkg -i metricbeat-7.6.1-amd64.deb

- name: drop in metricbeat config
  copy:
    src: /etc/ansible/metricbeat-config.yml
    dest: /etc/metricbeat/metricbeat.yml

- name: enable and configure docker module for metric beat
  command: metricbeat modules enable docker

- name: setup metric beat
  command: metricbeat setup

- name: start metric beat
  command: sudo service metricbeat start

- name: enable service metricbeat on boot
  systemd:
    name: metricbeat
    enabled: yes
```

### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the Damn Vulnerable Web Application.

Load balancing ensures that the application will be highly available, in addition to restricting access to the network.


Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the logs and system traffic.


The configuration details of each machine may be found below.
_Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table_.

| Name     | Function | IP Address | Operating System |
|----------|----------|------------|------------------|
| Jump Box | Gateway  | 10.0.0.12  | Linux            |
| ELK VM   |  ELK     | 10.1.0.4   | Linux            |
| Web-1    |  DVWA    | 10.0.0.13  | Linux            |
| Web-2    |  DVWA    | 10.0.0.9   | Linux            |
| Web-3    |  DVWA    | 10.0.0.14  | Linux            |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the Jump Box machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
My personal IP Address

Machines within the network can only be accessed by Ansible container that is inside of the Jump Box VM. 10.0.0.12/32

A summary of the access policies in place can be found in the table below.

| Name          | Publicly Accessible | Allowed IP Addresses |
|---------------|---------------------|----------------------|
| Jump Box      | Yes                 | Personal IP Address  |
| Web-1         | No                  | 10.0.0.12            |
| Web-2         | No                  | 10.0.0.12            |
| Web-3         | No                  | 10.0.0.12            |
| ELK VM        | No                  | 10.0.0.12            |
| Load Balancer | Yes                 | No Access Policies   |

### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because it is easy to install these systems on to multiple servers, and also makes the process go quicker than individually installing each part.

The playbook implements the following tasks:
- Install Docker.io and pip3
- Increases VM memory
- Download and Configure elk docker container
- Sets Published Ports

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![](https://github.com/shadowlockie1/shadowlockie1/blob/main/Images/docker_ps_output.png)

### Target Machines & Beats
This ELK server is configured to monitor the following machines:
- Web-1 : 10.0.0.13
- Web-2 : 10.0.0.9
- Web-3 : 10.0.0.14

We have installed the following Beats on these machines:
- Filebeat
- Metricbeat

These Beats allow us to collect the following information from each machine:
- Filebeat will collect log files and log data from the machine.
- Metricbeat will collect all metric data and statistical data from the machine.

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the Playbook.yml file to Ansible Container.
- Update the hosts file to include:

[webservers]
10.0.0.13 ansible_python_interpreter=/usr/bin/python3
10.0.0.9 ansible_python_interpreter=/usr/bin/python3
10.0.0.14 ansible_python_interpreter=/usr/bin/python3

[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3
- Run the playbook, and navigate to Elk-Public-IP:5601/app/kibana to check that the installation worked as expected.


- _Which file is the playbook? Where do you copy it?_
- The Playbook is INSTALL-ELK.YML
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- We update the hosts file and add the Web-VMs in the webservers section, and the ELK vm in the elk section, we then make sure that inside of the playbook, the host option is pointing to the correct one, either webservers or elk
- _Which URL do you navigate to in order to check that the ELK server is running?
- Elk-Public-IP:5601/app/kibana

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._

The commands that are needed to run the Anisble Configuration for the Elk-Server are:
```
1. ssh sysadmin@20.37.248.12
2. sudo docker container list -a
3. sudo docker start zen_rubin
4. sudo docker attach zen_rubin
5. cd /etc/ansible
6. ansible-playbook elk-playbook.yml
7. cd /etc/ansible/
8. ansible-playbook filebeat/metricbeat-playbook.yml
```
