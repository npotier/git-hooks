#!/bin/bash


# Récupération des scripts
curl https://raw.github.com/npotier/git-hooks/master/phpcs-pre-commit/pre-commit -o ./.git/hooks/pre-commit 
curl https://raw.github.com/npotier/git-hooks/master/phpcs-pre-commit/config-dist -o ./.git/hooks/config 
chmod u+x ./.git/hooks/pre-commit 

# Suppression eventuelle du fichier pre-commit.sample
if [ -f ./.git/hooks/pre-commit.sample ]
then
    rm ./.git/hooks/pre-commit.sample
fi 


# Configuration interactive de l'outil
echo "Welcome to PHPCS / PHPMD pre commit hook for Git projects"

PHPCS_BIN=$(which phpcs)

PHPCS_CODESTATUS=$?
if [ $PHPCS_CODESTATUS -ne 0 ]; then 
	echo "PHP Code Sniffer has not been found, so it won't be enabled"
	sed -i 's/{ENABLE_PHPCS_VALUE}/0/g' ./.git/hooks/config
else
	sed -i "s|{PHPCS_BIN_VALUE}|$PHPCS_BIN|g" ./.git/hooks/config
	
	echo -n "Do you want to enable PHP Code Sniffer in your project : y/n  (default : yes) ? "
	read ans
	case "$ans" in
		n|no|NO) 
			sed -i 's/{ENABLE_PHPCS_VALUE}/0/g' ./.git/hooks/config 
			;;
		*) 
			sed -i 's/{ENABLE_PHPCS_VALUE}/1/g' ./.git/hooks/config 
			PHPCS_CODING_STANDARD_AVAILABLE=$(phpcs -i)
			PHPCS_CODING_STANDARD_AVAILABLE=${PHPCS_CODING_STANDARD_AVAILABLE/The installed coding standards are/}
			while true; do
				echo -n "Which coding standard do you want to use (available : $PHPCS_CODING_STANDARD_AVAILABLE) ? "
				read ans
				case "$ans" in
					*)
						#TAB_CS=$(echo $PHPCS_CODING_STANDARD_AVAILABLE | tr " ")
						TAB_CS=(`echo $PHPCS_CODING_STANDARD_AVAILABLE | tr " " "\n"`)
						match=$(echo "${TAB_CS[@]:0}" | grep -o $ans)  
						if [[ ! -z $match ]]; then 
							sed -i "s|{PHPCS_CODING_STANDARD_VALUE}|$ans|g" ./.git/hooks/config
							break  
						else	
							echo "$ans is not recognized as an available coding standard"
						fi
						;;
				esac
			done
			;;
	esac

	echo -n "Do you want to ignore PHP Code Sniffer warnings : y/n  (default : yes) ? "
	read ans
	case "$ans" in
		n|no|NO) 
			sed -i 's/{PHPCS_IGNORE_WARNINGS_VALUE}/0/g' ./.git/hooks/config 

			;;
		*) 
			sed -i 's/{PHPCS_IGNORE_WARNINGS_VALUE}/1/g' ./.git/hooks/config 
			;;
	esac
	echo -n "What is the file encofing system that you use (utf-8, iso-8859-1) ? (default : iso-8859-1) ? "
	read ans
	case "$ans" in
		*) 
			sed -i 's/{PHPCS_ENCODING}/$ans/g' ./.git/hooks/config 
			;;
	esac
fi

PHPMD_BIN=$(which phpmd)

PHPMD_CODESTATUS=$?
if [ $PHPMD_CODESTATUS -ne 0 ]; then 
	echo "PHP Mess detector has not been found, so it won't be enabled"
	sed -i 's/{ENABLE_PHPMD_VALUE}/0/g' ./.git/hooks/config
else
	sed -i "s|{PHPMD_BIN_VALUE}|$PHPMD_BIN|g" ./.git/hooks/config

	echo -n "Do you want to enable PHP Mess Detector in your project : y/n  (default : yes) ? "
	read ans
	case "$ans" in
		n|no|NO) 
			sed -i 's/{ENABLE_PHPMD_VALUE}/0/g' ./.git/hooks/config 
			;;
		*) 
			sed -i 's/{ENABLE_PHPMD_VALUE}/1/g' ./.git/hooks/config 
			echo -n "Enter a comma separated list of ruleset that you want to use : (default : codesize,design,naming,unusedcode) ? "
			read ans
			case "$ans" in
			"")
				sed -i 's/{PHPMD_RULESETS_VALUE}/codesize,design,naming,unusedcode/g' ./.git/hooks/config 	
				;;			
			*) 
				sed -i 's/{PHPMD_RULESETS_VALUE}/$ans/g' ./.git/hooks/config 	
				;;
			esac
			;;
	esac
fi


echo -n "Do you want to log the output pre-commit hook in a file : y/n  (default : yes) ? "
read ans
case "$ans" in
	n|no|NO) 
		sed -i 's/{PRECOMMIT_LOG_VALUE}/0/g' ./.git/hooks/config 
		;;
	*) 
		sed -i 's/{PRECOMMIT_LOG_VALUE}/1/g' ./.git/hooks/config 
			echo -n "pre-commit hook log filename (default : .pre-commit-log) ? "
			read ans
			case "$ans" in
			"")
				sed -i 's/{PRECOMMIT_LOG_FILE_VALUE}/.pre-commit-log/g' ./.git/hooks/config 	
				;;			
			*) 
				sed -i 's/{PRECOMMIT_LOG_FILE_VALUE}/$ans/g' ./.git/hooks/config 	
				;;
			esac
		;;
esac

echo -n "Do you want to block commit if errors have been found : y/n (default: yes) ? "
read ans
case "$ans" in
	n|no|NO) 
		sed -i 's/{BLOCK_ON_ERRORS}/0/g' ./.git/hooks/config 
		;;
	*) 
		sed -i 's/{BLOCK_ON_ERRORS}/1/g' ./.git/hooks/config 
			echo -n "pre-commit hook log filename (default : .pre-commit-log) ? "
		;;
esac

echo "\n\n \033[0;32m....D O N E....!\033[0m"
echo "\n\n \033[0;32m....the pre-commit hook is now installed.\033[0m"