# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/init-es/init-es-0.3-r1.ebuild,v 1.2 2003/08/06 07:44:16 vapier Exp $

DESCRIPTION="Traductor de mensajes de inicio (init)"
HOMEPAGE="http://projects.frikis.org/"
SRC_URI="http://projects.frikis.org/gentoo/init-es/programa/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

RDEPEND="sys-apps/textutils
	sys-apps/sed"

src_install() {
	insinto /etc
	doins ${WORKDIR}/${P}/trad.es
	cd ${WORKDIR}/${P}/doc
	dodoc README ChangeLog
	exeinto /sbin
	doexe ${WORKDIR}/${P}/functions.sh
}

pkg_preinst() {
	if [ ! -f /sbin/functions.sh.ORIG ]
	then
		mv /sbin/functions.sh /sbin/functions.sh.ORIG
	fi
	if [ -f /sbin/functions.sh.ORIG ]
	then
		rm /sbin/functions.sh
	fi
}

pkg_postrm() {
	if [ ! -f /sbin/functions.sh ]
	then
		mv /sbin/functions.sh.ORIG /sbin/functions.sh
	fi
}
