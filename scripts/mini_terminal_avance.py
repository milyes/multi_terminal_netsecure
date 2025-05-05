import os

def afficher_menu():
    print("\n=== Mini Terminal IA ===")
    print("1. Afficher les fichiers")
    print("2. Informations système")
    print("3. Lancer une commande")
    print("4. Quitter")

def lister_fichiers():
    fichiers = os.listdir(".")
    for f in fichiers:
        print("-", f)

def infos_systeme():
    print("Nom de l'utilisateur :", os.getenv("USER") or os.getenv("HOME"))
    print("Répertoire courant   :", os.getcwd())

def executer_commande():
    cmd = input("Commande à exécuter : ")
    os.system(cmd)

def main():
    while True:
        afficher_menu()
        choix = input("Choisissez une option : ")
        if choix == "1":
            lister_fichiers()
        elif choix == "2":
            infos_systeme()
        elif choix == "3":
            executer_commande()
        elif choix == "4":
            print("Fermeture du mini terminal.")
            break
        else:
            print("Option invalide.")

if __name__ == "__main__":
    main()
