# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/globespan-adsl/globespan-adsl-0.9.ebuild,v 1.2 2004/06/24 22:26:46 agriffis Exp $

inherit fixheadtails

IUSE="tcltk"

MY_PN="eciadsl-usermode-0.9"
S=${WORKDIR}/${MY_PN}
DESCRIPTION="Driver for various ADSL modems. Also known as EciAdsl."
SRC_URI="http://eciadsl.flashtux.org/download/${MY_PN}.tar.gz"
HOMEPAGE="http://eciadsl.flashtux.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"

DEPEND=">=net-dialup/ppp-2.4.1"
RDEPEND="${DEPEND}
	tcltk? ( >=dev-lang/tk-8.3.4 )"


src_unpack() {
	unpack ${A} || die
	cd ${S} || die
	ht_fix_all
}

src_compile() {
	BIN_DIR="/usr/bin"
	BIN_DIR=${BIN_DIR} ./configure --prefix=/usr --conf-prefix=/etc \
	 --conf-dir=/eciadsl  --doc-prefix=/usr/share/doc --doc-dir=/eciads \
	 || die "./configure failed"
	emake || die "make failed"
}

src_install() {
	make ROOT=${D} install || die "Install failed"
}
pkg_postinst() {
	echo
	einfo "Package succesfully installed you should now run "
	einfo "eciconf.sh (graphical, requires TCL/TK) or eciconftxt.sh"
	echo
	einfo "Paquetage install� avec succ�s vous devriez maintenant"
	einfo "executer eciconf.sh (qui requiert TCL/TK) ou eciconftxt.sh"
	echo
	ewarn "Please note that if you're using a 2.6.x kernel you'll"
	ewarn "probably need to apply a patch to fix a USB bug. See"
	ewarn "http://eciadsl.flashtux.org/download/beta/"
	echo
}
