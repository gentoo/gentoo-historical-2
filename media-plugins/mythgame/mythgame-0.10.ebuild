# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mythgame/mythgame-0.10.ebuild,v 1.1 2003/07/08 23:44:01 johnm Exp $

inherit flag-o-matic

IUSE=""
DESCRIPTION="Game emulator module for MythTV."
HOMEPAGE="http://www.mythtv.org/"
SRC_URI="http://www.mythtv.org/mc/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=media-tv/mythtv-${PV}
	sys-libs/zlib
	>=sys-apps/sed-4"

src_unpack() {

	unpack ${A}

	for i in `grep -lr "usr/local" "${S}"` ; do
		sed -e "s:/usr/local:/usr:" -i "${i}" || die "sed failed"
	done

}

src_compile() {

	cpu="`get-flag march`"
	if [ ! -z "${cpu}" ] ; then
		sed -e "s:pentiumpro:${cpu}:g" -i "${S}/settings.pro" || die "sed failed"
	fi

	qmake -o "${S}/Makefile" "${S}/${PN}.pro"

	emake || die "compile problem"

}

src_install () {

	make INSTALL_ROOT="${D}" install || die "make install failed"

	insinto "/usr/share/mythtv/database/${PN}"
	doins gamedb/*.sql  

	dodoc README UPGRADING gamelist.xml

}

pkg_postinst() {

	einfo "If this is the first time you install MythGame,"
	einfo "you need to add /usr/share/mythtv/database/${PN}/metadata.sql"
	einfo "/usr/share/mythtv/database/${PN}/nesdb.sql and "
	einfo "/usr/share/mythtv/database/${PN}/snesdata.sql"
	einfo "to your MythTV database in that order."
	einfo
	einfo "You might run in this order:"
	einfo "'mysql < /usr/share/mythtv/database/${PN}/gamemetadata.sql'"
	einfo "'mysql < /usr/share/mythtv/database/${PN}/nesdb.sql'"
	einfo "'mysql < /usr/share/mythtv/database/${PN}/snesdata.sql'"
	einfo
	einfo "If you're upgrading from an older version and for more"
	einfo "setup and usage instructions, please refer to:"
	einfo "   /usr/share/doc/${PF}/README.gz"
	einfo "   /usr/share/doc/${PF}/UPGRADING.gz"
	ewarn "This part is important as there might be database changes"
	ewarn "which need to be performed or this package will not work"
	ewarn "properly."
	echo

}
