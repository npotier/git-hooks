PHP Codesniffer and PHP Mess Detector Pre-Commit Hook for GIT
================================
Author : Nicolas Potier <nicolas.potier@acseo-conseil.fr>

Based on work made by Soenke Ruempler <soenke@ruempler.eu>
Website: http://github.com/s0enke/git-hooks

# REQUIREMENTS

 * Bash
 * PHP CodeSniffer: http://pear.php.net/package/PHP_CodeSniffer/redirected
 * PHP Mess Detector : http://phpmd.org/


# FEATURES

 * Configuration file in order to :
 * * Define if the error will block the commit or not
 * * log the output in a file
 * Shows output in a 'less' pipe following the smart git principles
 

# INSTALLATION

You can use the setup script install.sh with curl : 
```bash
wget --no-check-certificate https://raw.github.com/npotier/git-hooks/master/phpcs-pre-commit/install.sh -O ./install.sh && chmod +x ./install.sh && ./install.sh
```