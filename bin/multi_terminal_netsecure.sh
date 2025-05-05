#!/data/data/com.termux/files/usr/bin/bash

echo "███╗   ██╗███████╗████████╗███████╗ ██████╗██████╗ ███████╗"
echo "████╗  ██║██╔════╝╚══██╔══╝██╔════╝██╔════╝██╔══██╗██╔════╝"
echo "██╔██╗ ██║█████╗     ██║   █████╗  ██║     ██████╔╝███████╗"
echo "██║╚██╗██║██╔══╝     ██║   ██╔══╝  ██║     ██╔══██╗╚════██║"
echo "██║ ╚████║███████╗   ██║   ███████╗╚██████╗██║  ██║███████║"
echo "╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝╚═╝  ╚═╝╚══════╝"
echo "                Terminal IA NetSecurePro"


# Fichiers utilisés
OPTIONS_FILE="termux_custom_options.txt"
DETECTED_COMMANDS="termux_detected_commands.txt"
LOG_FILE="termux_log.txt"
PYTHON_SCRIPT="mini_terminal_avance.py"

# Contenu du mini terminal IA (Python)
cat <<EOF > $PYTHON_SCRIPT
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
EOF

# Initialisation fichiers si absents
[ ! -f "$OPTIONS_FILE" ] && touch "$OPTIONS_FILE"
[ ! -f "$DETECTED_COMMANDS" ] && touch "$DETECTED_COMMANDS"
[ ! -f "$LOG_FILE" ] && touch "$LOG_FILE"

# Fonctions Bash
afficher_cadre() {
    echo -e "\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "📌 $1"
    echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

detecter_commandes() {
    afficher_cadre "🔍 Détection automatique des commandes exécutables (binaires et scripts)"
    
    PATHS="/data/data/com.termux/files/usr/bin $HOME/bin $PREFIX/bin"
    > "$DETECTED_COMMANDS"

    for dir in $PATHS; do
        if [ -d "$dir" ]; then
            find "$dir" -type f -executable -exec basename {} \; >> "$DETECTED_COMMANDS"
        fi
    done

    sort -u -o "$DETECTED_COMMANDS" "$DETECTED_COMMANDS"
    echo "✅ $(wc -l < "$DETECTED_COMMANDS") commandes détectées et listées dans $DETECTED_COMMANDS"
}

afficher_options() {
    afficher_cadre "📂 Commandes disponibles"
    cat -n "$DETECTED_COMMANDS"
    if [ -s "$OPTIONS_FILE" ]; then
        echo -e "\n⭐ Commandes personnalisées :"
        cat -n "$OPTIONS_FILE"
    fi
}

executer_par_selection() {
    afficher_options
    read -p "Numéro de la commande à exécuter : " num
    option=$(sed -n "${num}p" "$OPTIONS_FILE")
    [ -z "$option" ] && option=$(sed -n "${num}p" "$DETECTED_COMMANDS")
    if [ -n "$option" ]; then
        read -p "Confirmer l'exécution de '$option' ? (o/n) : " confirm
        [[ "$confirm" =~ ^[oO]$ ]] && echo -e "\n$option\n$(eval "$option")" | tee -a "$LOG_FILE"
    else
        echo "❌ Numéro invalide."
    fi
}

saisie_manuel() {
    read -p "Commande à exécuter : " cmd
    read -p "Confirmer '$cmd' ? (o/n) : " confirm
    [[ "$confirm" =~ ^[oO]$ ]] && echo -e "\n$cmd\n$(eval "$cmd")" | tee -a "$LOG_FILE"
}

ajouter_option() {
    read -p "Nouvelle commande personnalisée : " cmd
    echo "$cmd" >> "$OPTIONS_FILE"
    echo "✅ Commande ajoutée."
}

supprimer_option() {
    afficher_options
    read -p "Numéro de la commande à supprimer : " num
    sed -i "${num}d" "$OPTIONS_FILE" && echo "✅ Supprimée."
}

# Menu principal
while true; do
    echo -e "\n=== MENU MULTI TERMINAL ==="
    echo "1. Détecter les commandes Termux"
    echo "2. Afficher les options"
    echo "3. Exécuter une commande par sélection"
    echo "4. Saisir une commande manuelle"
    echo "5. Ajouter une commande personnalisée"
    echo "6. Supprimer une commande personnalisée"
    echo "7. Lancer le Mini Terminal IA (Python)"
    echo "8. Voir les logs"
    echo "9. Quitter"
echo "16. Importer commandes binaires depuis un fichier JSON"
echo "17. Ouvrir la base de données SQLite et afficher les emprunts"


echo "15. Lancer FastAPI Emprunts IA (port 8000)"


    read -p "Choix : " choix

    case $choix in
        1) detecter_commandes ;;
        2) afficher_options ;;
        3) executer_par_selection ;;
        4) saisie_manuel ;;
        5) ajouter_option ;;
        6) supprimer_option ;;
        7) python3 "$PYTHON_SCRIPT" ;;
        8) tail -n 10 "$LOG_FILE" ;;
        9) echo "Fermeture du terminal." && break ;;
        
    15)
        echo "🚀 Lancement de FastAPI Emprunts IA sur le port 8000..."
        cd ~/fastapi_emprunts_netsecure/app || exit
        uvicorn main:app --host 0.0.0.0 --port 8000
        ;;
        
    16)
        echo "📂 Entrez le chemin du fichier JSON à importer :"
        read fichier
        if [ -f "$fichier" ]; then
            curl -X POST -F "file=@$fichier" http://127.0.0.1:8000/import_json
        else
            echo "❌ Fichier introuvable."
        fi
        ;;
        
    17)
        DB_PATH="$HOME/fastapi_emprunts_netsecure/app/emprunts.db"
        if [ -f "$DB_PATH" ]; then
            echo "📂 Contenu de la base de données SQLite ($DB_PATH) :"
            sqlite3 "$DB_PATH" "SELECT * FROM emprunts;"
        else
            echo "❌ Base de données introuvable : $DB_PATH"
        fi
        ;;
        *) echo "❌ Choix invalide." ;;
    esac
done
