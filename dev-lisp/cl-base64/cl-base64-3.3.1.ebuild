# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-base64/cl-base64-3.3.1.ebuild,v 1.2 2004/05/09 15:02:33 dholm Exp $

inherit common-lisp

DESCRIPTION="Common Lisp package to encode and decode base64 with URI support"
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-base64.html
	http://b9.com/debian.html"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-base64/${PN}_${PV}.orig.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
DEPEND="dev-lisp/cl-kmrcl"

CLPACKAGE=cl-base64

S=${WORKDIR}/${P}

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc COPYING
}
