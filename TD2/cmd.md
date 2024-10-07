# TD2

## Utilisation du script container.sh

1. Fonctionnalités du script :
   - Crée 10 conteneurs Docker basés sur l'image `basilelt/debian-full:latest`
   - Attribue à chaque conteneur un port SSH unique, commençant à 2222
   - Vérifie si les conteneurs existent déjà et les démarre si nécessaire
   - Affiche les adresses IP et les ports SSH de chaque conteneur

2. Rôle dans le projet :
   - Simule un environnement multi-serveurs pour les exercices Ansible
   - Permet de pratiquer la gestion de configuration sur plusieurs machines
   - Facilite les tests d'inventaire et de playbooks Ansible

3. Après exécution :
   - Utilisez les informations de port SSH fournies pour configurer votre inventaire Ansible
   - Les conteneurs sont accessibles via SSH sur localhost avec les ports attribués

## Exercice 1

1. `ansible -i inventory.ini "node2," -m ping`
3. `ansible -i inventory.ini "node2," -m shell -a "uptime; ls; pwd"`
4. `ansible -i inventory.ini "node2," -e "var1=Bonjour" -m debug -a "var=var1"`
5. `ansible -i inventory.ini "node2," -m copy -a "src=./cmd.md dest=/home/toto/cmd.md"`
6. `ansible -i inventory.ini "node2," -m fetch -a "src=/home/toto/cmd.md dest=/tmp/fetched_cmd.md flat=yes"`
7. `ansible -i inventory.ini "node2," -m shell -a "ps aux | wc -l"`
   
## Exercice 2

5. `ansible -i inventory.yml all -m debug -a 'msg={{ group_message | default("No group message") }}'`
   La valeur affichée pour les nœuds 6 et 7 est : 
   ```bash
        node6 | SUCCESS => {
            "msg": "Ici c'est le groupe common"
        }
        node7 | SUCCESS => {
            "msg": "Ici c'est le groupe common"
        }
    ```
6. 
    ```bash
        mkdir -p group_vars host_vars
        
        # Create group_vars files
        touch group_vars/all.yml
        touch group_vars/webserver.yml
        touch group_vars/dbserver.yml
        touch group_vars/common.yml
        touch group_vars/nocommon.yml

        # Create host_vars file
        touch host_vars/node5.yml
    ```
    `ansible -i inventory.yml all -m debug -a "msg=\"Group Message: {{ group_message | default('No group message') }}, Node Message: {{ node_message | default('No node message') }}\""`

    On remarque que les variables définies dans les fichiers `group_vars` et `host_vars` sont prioritaire sur celles définies dans le fichier `inventory.yml`(surcharge).

11. Pour Mac OS
    `ansible-inventory-grapher -i inventory.yml all | dot -Tpng > inventory_graph.png && open inventory_graph.png`
   
## Exercice 3

1. `ansible-playbook -i inventory.yml playbook.yml`
    On obtient un résumé de la connexion ainsi que le message de debug propres à chaques noeuds.

3. 
    a. `ansible-playbook -i inventory.yml playbook.yml -K`
        On est invité à entrer le mot de passe de l'utilisateur root avec le flag `-K`.
        ```bash
            TASK [Display directory owner] ***********************************************************************************************************************
            ok: [node2] => {
                "msg": "The owner of the directory is root"
            }
        ```
        Le propriétaire du dossier est `root`.

    b. `ansible-playbook -i inventory.yml playbook_b.yml`
        ```bash
            TASK [Display directory owner and permissions] **************************************************
            ok: [node2] => {
                "msg": "The directory /home/toto/test_directory is owned by root"
            }
        ```
        Le propriétaire du dossier est `toto`.

    c. `ansible-playbook -i inventory.yml playbook_c.yml -K`
        On est invité à entrer le mot de passe de l'utilisateur root avec le flag `-K`.
        ```bash
            TASK [Display directory owner and permissions] **************************************************
            ok: [node2] => {
                "msg": "The directory /home/toto/test_directory is owned by toto:toto with permissions 0755"
            }
        ```
        Le propriétaire du dossier est `toto:toto` avec les permissions `0755`.

4. `ansible-playbook -i inventory.yml playbook_defg.yml -K --step`

## Exercice 4

1. 