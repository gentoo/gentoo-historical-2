# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-www/phpmp/phpmp-0.10.2.ebuild,v 1.1 2004/05/23 14:27:37 mholzer Exp $

inherit webapp

MY_PN="phpMp"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="phpMp is a client program for Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org/"
SRC_URI="mirror://sourceforge/musicpd/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"
IUSE=""

DEPEND=">=dev-php/mod_php-4.2.3-r2"

src_install() {
	webapp_src_preinst

	local docs="COPYING ChangeLog INSTALL README TODO"
	
	dodoc ${docs}
	for doc in ${docs} INSTALL; do
			rm -f ${doc}
	done

	cp -r . ${D}${MY_HTDOCSDIR}


	webapp_configfile ${MY_HTDOCSDIR}/config.php

	webapp_postinst_txt en ${FILESDIR}/postinstall-en.txt

	webapp_src_install
}
