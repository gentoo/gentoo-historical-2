# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/vanessa-adt/vanessa-adt-0.0.4_beta4.ebuild,v 1.1 2003/03/15 07:52:26 george Exp $

DESCRIPTION="Provides Abstract Data Types (ADTs) Includes queue, dynamic array, hash and key value ADT."
HOMEPAGE="http://www.vergenet.net/linux/vanessa/"
SRC_URI="http://www.vergenet.net/linux/perdition/download/BETA/1.11beta5/vanessa_adt-0.0.4beta4.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND=">=vanessa-logger-0.0.4_beta2"
S=${WORKDIR}/vanessa_adt-0.0.4beta4

src_compile() {
	econf

	emake || die
}

src_install() {
	einstall
	dodoc AUTHORS NEWS README TODO
}
