import yaml as y

if __name__ == "__main__":
    with open('myfile.yaml','r') as yaml_file:
        ouryaml = y.safe_load(yaml_file)

    print(ouryaml)

    print("---")

    print(f"access_token: {ouryaml['access_token']}")
    print(f"expires_in: {ouryaml['expires_in']}")
    