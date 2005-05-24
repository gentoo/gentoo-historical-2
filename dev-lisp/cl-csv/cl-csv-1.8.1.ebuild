# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/cl-csv/cl-csv-1.8.1.ebuild,v 1.7 2005/05/24 18:48:33 mkennedy Exp $

inherit common-lisp

DESCRIPTION="CL-CSV is a Common Lisp library for importing CSV (Common Separated Values) formatted text files"
HOMEPAGE="http://packages.debian.org/unstable/devel/cl-csv"
SRC_URI="http://ftp.debian.org/debian/pool/main/c/cl-csv/cl-csv_${PV}.orig.tar.gz"
LICENSE="No-Problem-Bugroff"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""
DEPEND="dev-lisp/common-lisp-controller
	virtual/commonlisp"

CLPACKAGE=csv


src_install() {
	common-lisp-install *.lisp *.asd
	common-lisp-system-symlink
}
