# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/ydpdict/ydpdict-0.63.ebuild,v 1.2 2005/01/01 13:04:09 eradicator Exp $

DESCRIPTION="A Linux interface for the Collins Polish-English, English-Polish Dictionary."
HOMEPAGE="http://toxygen.net/ydpdict/"
SRC_URI="http://toxygen.net/${PN}/${P}.tar.gz"
SLOT="0"
DEPEND=""
IUSE=""
LICENSE="GPL-2"
KEYWORDS="~x86"

src_compile() {
	econf || die
	emake || die
}

src_install() {
	mkdir -p ${D}/{usr/bin,etc}
	einstall || die
	dodoc README
	sed -i "s#/usr/local/share/ydpdict#/usr/share/ydpdict#" ydpdict.conf.example
	cp ydpdict.conf.example ${D}/etc/ydpdict.conf
}

pkg_postinst() {
	echo ""
	einfo "Note that to use this program you'll need the original Collins Dictionary"
	einfo "datafiles (dict100.*, dict101.*). These can be found in the Dabasase/"
	einfo "directory of the Windows version of the Collins dictionary. Once you obtain"
	einfo "the files, put them into /usr/share/ydpdict"
	einfo
	einfo "Some configuration options can be set in /etc/ydpdict.conf"
	echo ""
}
