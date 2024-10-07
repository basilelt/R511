# TD2

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
        mkdir -p group_vars host_vars`
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
   
