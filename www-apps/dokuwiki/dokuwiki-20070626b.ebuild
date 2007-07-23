# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/dokuwiki/dokuwiki-20070626b.ebuild,v 1.2 2007/07/23 09:00:41 ticho Exp $

inherit webapp depend.php

# Upstream uses dashes in the datestamp
MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}${PV:8:1}"

DESCRIPTION="DokuWiki is a simple to use Wiki aimed at a small companies
documentation needs."
HOMEPAGE="http://wiki.splitbrain.org/wiki:dokuwiki"
SRC_URI="http://www.splitbrain.org/_media/projects/${PN}/${PN}-${MY_PV}.tgz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="virtual/php"
RDEPEND="${DEPEND}"

pkg_setup() {
	# let the eclass pick right php version...
	require_php_cli

	# ...and we check if correct USE flag for XML support is enabled
	if [[ ${PHP_VERSION} == "4" ]] ; then
		require_php_with_use expat
	else
		require_php_with_use xml
	fi

	webapp_pkg_setup
}

src_unpack() {
	cd ${WORKDIR}
	unpack ${PN}-${MY_PV}.tgz
	mv ${PN}-${MY_PV} ${P}
}

src_compile() {
	# Default compile hangs
	echo "Nothing to compile"
}

src_install() {
	local docs="README"
	webapp_src_preinst

	# NOTE: doc files should go into /usr/share/doc, and NOT installed in the vhost
	einfo "Installing docs"
	dodoc ${docs}
	for doc in ${docs} COPYING; do
		rm -f ${doc}
	done

	# Move bin directory to safe location (outside of docroot)
	# To resolve security bug #146800
	docinto scripts
	dodoc bin/*
	rm -rf bin

	einfo "Copying main files"
	cp -r . ${D}/${MY_HTDOCSDIR}

	# Install the htaccess file for pretty urls
	cp .htaccess ${D}/${MY_HTDOCSDIR}

	# Create initial changes file
	touch ${D}/${MY_HTDOCSDIR}/data/changes.log data/changes.log

	# The data dir needs to be owned by the server
	for x in `find . -print | grep "data/*" | grep -v .htaccess` ; do
		webapp_serverowned ${MY_HTDOCSDIR}/$x
	done

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt
	webapp_configfile ${MY_HTDOCSDIR}/.htaccess

	webapp_configfile ${MY_HTDOCSDIR}/conf

	# Mark all conf/* files as config files, except msg, which should be
	# updated unconditionally.
	for x in $( ls -1 ${D}/${MY_HTDOCSDIR}/conf | grep -v ^msg$ ) ; do
		webapp_configfile ${MY_HTDOCSDIR}/conf/$x
	done

	webapp_src_install
}
