# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/phpmp/phpmp-0.11.0.ebuild,v 1.5 2006/09/10 18:05:14 the_paya Exp $

IUSE=""

inherit webapp

MY_PN="phpMp"
MY_P="${MY_PN}-${PV}"
S=${WORKDIR}/${MY_P}
DESCRIPTION="phpMp is a client program for Music Player Daemon (mpd)"
HOMEPAGE="http://www.musicpd.org/"
SRC_URI="mirror://sourceforge/musicpd/${MY_P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="alpha amd64 ~ppc sparc x86 ~x86-fbsd"

DEPEND="virtual/httpd-php"

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
