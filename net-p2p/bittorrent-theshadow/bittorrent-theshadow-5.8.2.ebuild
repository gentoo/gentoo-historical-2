# Copyright 1999-2003 Gentoo Technologies, Inc., Okrain Genady (^Mafteah), and Luke-Jr
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/bittorrent-theshadow/bittorrent-theshadow-5.8.2.ebuild,v 1.1 2003/10/02 01:00:35 luke-jr Exp $

inherit distutils

S=${WORKDIR}/bittorrent-CVS-shadowsclient
DESCRIPTION="BitTorrent is a tool for distributing files via a distributed network of nodes"
SRC_URI="http://home.elp.rr.com/tur/BitTorrent-experimental-S-${PV}.zip"
HOMEPAGE="http://bt.degreez.net/"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

IUSE="X psyco nopsyco"

RDEPEND="X? ( >=dev-python/wxPython-2.2 )
	>=dev-lang/python-2.1
	!net-p2p/bittorrent
	!virtual/bittorrent
	psyco? ( dev-python/psyco )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4.0.5"

PROVIDE="virtual/bittorrent"

mydoc="FAQ.txt README.txt LICENSE.txt"


src_unpack() {
	unpack ${A}
	cd ${S}
	for f in `find -name \*.txt -or -name \*.py`; do
		tr -d '\r' < "$f" |
			sed "s/PSYCO.psyco/$((`use nopsyco&&echo -1`+1))/g" |
			grep -v 'import PSYCO' |
			sed 's/basepath=os\.path\.abspath(os\.path\.dirname(sys\.argv\[0\]))/basepath="\/usr\/share\/pixmaps\/bittorrent"/' |
			sed 's/wxConfig(\"BitTorrent\")/wxConfig(\"BitTorrent\", style=wxCONFIG_USE_LOCAL_FILE)/' \
			> "$f".new
		mv "$f".new "$f"
	done
}

src_install() {
	distutils_src_install
	if ! use X; then
		rm ${D}/usr/bin/*gui.py
	fi
	dodir etc
	cp -a /etc/mailcap ${D}/etc/

	dodir /usr/share/pixmaps/bittorrent
	for f in *.{ico,gif}; do
		install -m 644 "$f" "${D}/usr/share/pixmaps/bittorrent/$f"
	done

	MAILCAP_STRING="application/x-bittorrent; /usr/bin/btdownloadgui.py '%s'; test=test -n \"\$DISPLAY\""

	if use X; then
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
	fi
}

