# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ttytter/ttytter-2.0.01.ebuild,v 1.1 2012/07/02 18:26:36 hwoarang Exp $

EAPI="2"

DESCRIPTION="A multi-functional, console-based Twitter client"
HOMEPAGE="http://www.floodgap.com/software/ttytter/"
SRC_URI="http://www.floodgap.com/software/ttytter/dist2/${PV}.txt"

LICENSE="FFSL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND=">=dev-lang/perl-5.8
	|| ( net-misc/curl www-client/lynx )"

src_unpack() {
	cp "${DISTDIR}"/${A} "${S}" || die
}

src_install() {
	newbin "${S}" ttytter || die
}

pkg_postinst() {
	einfo
	einfo "Please consult the following webpage on how to"
	einfo "configure your client."
	einfo "http://www.floodgap.com/software/ttytter/dl.html"
	einfo
}
