# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/globespan-adsl/globespan-adsl-0.10.ebuild,v 1.1 2004/11/17 19:39:52 mrness Exp $

inherit fixheadtails

MY_PN="eciadsl-usermode-${PV}"
S=${WORKDIR}/${MY_PN}
DESCRIPTION="Driver for various ADSL modems. Also known as EciAdsl."
SRC_URI="http://eciadsl.flashtux.org/download/${MY_PN}.tar.gz"
HOMEPAGE="http://eciadsl.flashtux.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE="tcltk"

DEPEND=">=net-dialup/ppp-2.4.1"
RDEPEND="${DEPEND}
	tcltk? ( >=dev-lang/tk-8.3.4 )"

src_unpack() {
	unpack ${A} || die "failed to unpack"
	cd ${S} || die "source directory not found"
	ht_fix_all

	einfo "Correct obsolete nice parameters"
	sed -i -e 's:nice --:nice -n -:' eciadsl-{start,stop,doctor} || \
		die "failed to replace nice params"
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
	einfo
	einfo "Package succesfully installed you should now run "
	einfo "eciconf.sh (graphical, requires TCL/TK) or eciconftxt.sh"
	einfo
	einfo "Paquetage install� avec succ�s vous devriez maintenant"
	einfo "executer eciconf.sh (qui requiert TCL/TK) ou eciconftxt.sh"
	einfo
	ewarn "Please note that if you're using a 2.6.x kernel you'll"
	ewarn "probably need to apply a patch to fix a USB bug. See"
	ewarn "http://eciadsl.flashtux.org/download/beta/"
	einfo
}
