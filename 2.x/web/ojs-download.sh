#!/bin/bash
#http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'


echo "[OJS DOWNLOADER] Running in " $(pwd) " with parameters: OJS_URL_DOWNLOAD='${OJS_URL_DOWNLOAD}' OJS_PATH='${OJS_PATH}' OJS_GIT_URL=${OJS_GIT_URL} OJS_SVN_URL=${OJS_SVN_URL}"

# Installation instructions for 2.x: https://pkp.sfu.ca/ojs/README
# Do patches have to be applied here?

# Installation instructions for 3.x: https://github.com/pkp/ojs/tree/master/docs
# FOR 3.x only: Install composer Dependencies
#    && cd /var/www/html/lib/pkp \
#    && curl -sS https://getcomposer.org/installer | php \
#    && php composer.phar update

if [ "${OJS_URL_DOWNLOAD}" = "true" ]; then
    echo "[OJS DOWNLOADER] Downloading OJS version ${OJS_URL_VERSION} from URL http://pkp.sfu.ca/ojs/download/ojs-${OJS_URL_VERSION}.tar.gz to ${OJS_PATH}"
    curl -sSL -O "http://pkp.sfu.ca/ojs/download/ojs-${OJS_URL_VERSION}.tar.gz"
    tar -zxf ojs-${OJS_URL_VERSION}.tar.gz
    mv ojs-${OJS_URL_VERSION} ${OJS_PATH}
elif [ "${OJS_GIT_URL}" != "NA" ]; then
    echo "[OJS DOWNLOADER] Cloning OJS from git repo at ${OJS_GIT_URL} using tag ${OJS_GIT_TAG} to ${OJS_PATH} (after installing git first)"
    apt-get install git -y
    # need this to get checkout of submodules (--recursive) to work:
    git config --global url.https://.insteadOf git://
    # rm -fr /var/www/html/*
    git clone --progress https://github.com/pkp/ojs.git ${OJS_PATH}
    cd ${OJS_PATH}
    echo "[OJS DOWNLOADER] done initial clone... now in " $(pwd)
    if [ ! -z "${OJS_GIT_TAG}" ]; then
        git checkout tags/${OJS_GIT_TAG}
    fi
    # NOW pull submodules after tags/branches were checked out
    echo "[OJS DOWNLOADER] get submodules"
    git submodule update --init --recursive
    echo "[OJS DOWNLOADER] git status:"
    git status

    if [ "${OJS_VCS_CLEANUP}" = "true" ]; then
        echo "[OJS DOWNLOADER] cleaning up... removing git files and uninstalling git"
        # remove git files
        find . | grep .git | xargs rm -rf
        cd ..

        # remove git
        apt-get remove git -y
        apt-get autoremove -y
        apt-get clean -y
    fi
elif [ "${OJS_SVN_URL}" != "NA" ]; then
    echo "[OJS DOWNLOADER] Checking out OJS from SVN at ${OJS_SVN_URL} (username '${OJS_SVN_USER}') to ${OJS_PATH}"
    apt-get install subversion -y

    if [ ${OJS_SVN_USER} != "NA" -a ${OJS_SVN_PASS} != "NA" ]; then
        svn co ${OJS_SVN_URL} ${OJS_PATH} --username ${OJS_SVN_USER} --password ${OJS_SVN_PASS}
    else
        svn co ${OJS_SVN_URL} ${OJS_PATH}
    fi

    if [ "${OJS_VCS_CLEANUP}" = "true" ]; then
        echo "[OJS DOWNLOADER] cleaning up... removing .svn directories and uninstalling subversion"
        # remove .svn directories
        find . -name .svn -exec rm -rf {} \;

        # remove svn
        apt-get remove subversion -y
        apt-get autoremove -y
        apt-get clean -y
    fi
else
    echo "You must at least declare one of OJS_URL_DOWNLOAD=true, OJS_GIT_URL=https://..., or OJS_SVN_URL=svn://...!"
    exit 1
fi
