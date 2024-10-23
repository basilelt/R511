# TD3
Basile LE THIEC
RT31

## I)
### b)
1. 
Les forwarding ports correspondent aux ports de la machine hôte qui sont redirigés vers les ports de la machine virtuelle.

2. 
Le nom de la machine virtuelle est `TD3_default_1729667600724_55748`.

3. 
Le provider est `virtualbox`.

7. 
Suspendre :
```bash
vagrant suspend
```

Défreezer :
```bash
vagrant resume
```

8. 
Arrêter :
```bash
vagrant halt
```

Redémarrer :
```bash
vagrant reload
```

### d)
1. 
```bash
vagrant@vagrant:~$ ls /vagrant/
cr.md  TD3_IB.pdf  Vagrantfile
```

2. 
```bash
vagrant@vagrant:~$ cd /vagrant/
vagrant@vagrant:/vagrant$ touch test.txt
vagrant@vagrant:/vagrant$ exit
toto@debian ~/Documents/R511/TD3 main ± ls
cr.md  TD3_IB.pdf  test.txt  Vagrantfile
```

## III)
### a)
3. 
```bash
toto@debian ~/Documents/R511/TD3 main ± vagrant box list
centos/7           (virtualbox, 2004.01)
hashicorp/bionic64 (virtualbox, 1.0.282)
```

J'ai 2 box installées.

5. 
```bash
vagrant box add ubuntu/xenial64 --name my_vBOX
```

### c)
9. 
Il s'agit de la ligne 26 du fichier `Vagrantfile`.

11. 
Il faut utiliser le port `8080` pour accéder à la page web de la VM.

### d)
12. 
```bash
vagrant box add my-custom-ubuntu my-custom-ubuntu.box
```
14. 
La page web n'est pas accessible à l'adresse `http://127.0.0.1:8080`.

15. 
Pour la rendre accessible il faut à nouveau décommenter la ligne 26 du fichier `Vagrantfile`.
