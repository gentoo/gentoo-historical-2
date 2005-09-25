# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bittornado/bittornado-0.3.8.ebuild,v 1.7 2005/09/25 20:41:05 mkay Exp $

inherit distutils eutils

MY_PN="BitTornado"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="TheShad0w's experimental BitTorrent client"
HOMEPAGE="http://www.bittornado.com/"
SRC_URI="http://bittornado.com/download/${MY_P}.tar.gz"
LICENSE="MIT"
SLOT="0"

KEYWORDS="x86 amd64 ppc ~sparc ~ppc64"
IUSE="gtk"

RDEPEND="gtk? ( >=dev-python/wxpython-2.4 )
	>=dev-lang/python-2.1
	!virtual/bittorrent"
DEPEND="${RDEPEND}
	app-arch/unzip
	>=sys-apps/sed-4.0.5"
PROVIDE="virtual/bittorrent"

S="${WORKDIR}/${MY_PN}-CVS"
PIXMAPLOC="/usr/share/pixmaps/bittornado"

src_unpack() {
	unpack ${A}
	cd ${S}

	# fixes wrong icons path
	sed -i "s:os.path.abspath(os.path.dirname(os.path.realpath(sys.argv\[0\]))):\"${PIXMAPLOC}/\":" btdownloadgui.py
	# fixes a bug with < wxpython-2.5 which is not yet available in portage
	epatch ${FILESDIR}/${PN}-wxpython-pre2.5-fix.patch
}

src_install() {
	distutils_src_install

	dodir etc
	cp -pPR /etc/mailcap ${D}/etc/
	MAILCAP_STRING="application/x-bittorrent; /usr/bin/btdownloadgui.py '%s'; test=test -n \"\$DISPLAY\""

	if use gtk; then
		dodir ${PIXMAPLOC}
		insinto ${PIXMAPLOC}
		doins *.ico *.gif
		if [ -n "`grep 'application/x-bittorrent' ${D}/etc/mailcap`" ]; then
			# replace bittorrent entry if it already exists
			einfo "updating bittorrent mime info"
			sed -i "s,application/x-bittorrent;.*,${MAILCAP_STRING}," ${D}/etc/mailcap
		else
			# add bittorrent entry if it doesn't exist
			einfo "adding bittorrent mime info"
			echo "${MAILCAP_STRING}" >> ${D}/etc/mailcap
		fi
	else
		# get rid of any reference to the not-installed gui version
		sed -i '/btdownloadgui/d' ${D}/etc/mailcap
		rm ${D}/usr/bin/*gui.py
	fi
	insinto /usr/share/bittorrent
	doins ${FILESDIR}/favicon.ico

	insinto /etc/conf.d
	newins ${FILESDIR}/bttrack.conf bttrack

	exeinto /etc/init.d
	newexe ${FILESDIR}/bttrack.rc bttrack
}

