# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/zuul/zuul-1.1.2.ebuild,v 1.1 2003/10/01 13:06:58 lanius Exp $

HOSTNAME=`hostname`
DESCRIPTION="Zuul is yet another PHP front-end for mldonkey. It will allow full access to all the features of mldonkey including starting/viewing downloads, viewing uploads, viewing servers, and setting all the options."
HOMEPAGE="http://zuul.sourceforge.net"

# Handle RC versions
MY_PV="${PV/_/-}"
SRC_URI="mirror://sourceforge/zuul/${PN}-${MY_PV}.tar.gz"

SLOT="0"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE=""
RDEPEND="virtual/php
		>=net-p2p/mldonkey-2.5"
DEPEND=""

S="${WORKDIR}/${PN}-${MY_PV}"

HTTPD_ROOT="`grep -s '^DocumentRoot' /etc/apache/conf/apache.conf | cut -d\  -f2`"
[ -z "${HTTPD_ROOT}" ] && HTTPD_ROOT="`grep -s '^DocumentRoot' /etc/apache2/conf/apache2.conf | cut -d\  -f2`"
[ -z "${HTTPD_ROOT}" ] && HTTPD_ROOT="/home/httpd/htdocs"
HTTPD_USER="apache"
HTTPD_GROUP="apache"


src_compile() {
	echo "Nothing to compile"
}

src_install() {
	cd ${S}
	dodir ${HTTPD_ROOT}/zuul
	cp -r * ${D}/${HTTPD_ROOT}/zuul
}

pkg_postinst() {
	einfo
	einfo "Installation complete."
	einfo
	einfo "You need to configure zuul by editing"
	einfo "${HTTPD_ROOT}/zuul/conf/config.php and"
	einfo "${HTTPD_ROOT}/zuul/bin/startup.sh."
	einfo
	einfo "http://$HOSTNAME/zuul"
	einfo
}
