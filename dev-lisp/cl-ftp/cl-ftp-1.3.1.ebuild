# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-ftp/cl-ftp-1.3.1.ebuild,v 1.1 2004/02/03 07:32:46 mkennedy Exp $

inherit common-lisp

DESCRIPTION="CL-FTP is a Networking Library that provides FTP client (for now) functionality to Common Lisp programs."
HOMEPAGE="http://www.mapcar.org/~mrd/cl-ftp/
	http://packages.debian.org/unstable/devel/cl-ftp
	http://www.cliki.net/CL-FTP"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-ftp/${PN}_${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp
	dev-lisp/cl-acl-compat
	dev-lisp/cl-split-sequence"

S=${WORKDIR}/${P}

CLPACKAGE=ftp

src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
	dodoc LICENSE
}

pkg_preinst() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}

pkg_postrm() {
	rm -rf /usr/lib/common-lisp/*/${CLPACKAGE} || true
}
