import yaml as y

if __name__ == "__main__":
    with open('person.yaml','r') as yaml_file:
        ouryaml = y.safe_load(yaml_file)

    print(ouryaml)

    print("---")

    print(f"Nom: {ouryaml['nom']}")
    print(f"Age: {ouryaml['age']}")
    
    print("---")
    
    print(f"Numéro: {ouryaml['adresse']['numero']}")
    print(f"Rue: {ouryaml['adresse']['rue']}")
    print(f"Ville: {ouryaml['adresse']['ville']}")
    print(f"Pays: {ouryaml['adresse']['pays']}")
    
    print("---")
    
    print(f"langages: {ouryaml['langages'][0]}")
    print(f"langages: {ouryaml['langages'][1]}")
    print(f"langages: {ouryaml['langages'][2]}")
    
    print("---")
    
    print(f"Loisirs: {ouryaml['loisirs'][0]}")
    print(f"Loisirs: {ouryaml['loisirs'][1]}")
    print(f"Loisirs: {ouryaml['loisirs'][2]}")
    