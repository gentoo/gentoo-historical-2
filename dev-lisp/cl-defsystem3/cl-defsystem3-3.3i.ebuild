# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-defsystem3/cl-defsystem3-3.3i.ebuild,v 1.6 2004/06/24 23:42:40 agriffis Exp $

DESCRIPTION="Another System Definition Facility for Common Lisp"
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-defsystem3.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-defsystem3/${PN}_${PV}+cvs.2003.04.30.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~sparc"
IUSE=""
DEPEND=""

S=${WORKDIR}/${P}+cvs.2003.04.30

src_unpack() {
	unpack ${A}
	mv ${S}/docs/defsystem.text ${S}/docs/defsystem.txt
}

src_install() {
	insinto /usr/share/common-lisp/source/defsystem
	doins defsystem.lisp

	dodoc ChangeLog README docs/defsystem.txt
	dohtml docs/defsystem.html
}

pkg_postinst() {
	if [ -x /usr/sbin/clc-reregister-all-impl ]; then
		/usr/sbin/clc-reregister-all-impl
	fi
}
