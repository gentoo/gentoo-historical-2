# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/reportlab/reportlab-1.20.ebuild,v 1.12 2006/06/27 22:53:14 jer Exp $

#goofy tarball versioning
vmaj=${PV%%.*}
vmin=${PV##*.}

inherit python distutils

S=${WORKDIR}/${PN}
DESCRIPTION="Tools for generating printable PDF documents from any data source."
SRC_URI="http://www.reportlab.org/ftp/ReportLab_${vmaj}_${vmin}.tgz"
HOMEPAGE="http://www.reportlab.org/"

DEPEND=">=sys-libs/zlib-0.95
	dev-python/imaging
	>=sys-apps/sed-4
	app-arch/tar"

IUSE=""
SLOT="0"
LICENSE="as-is"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"

src_unpack() {
	unpack ${A} || die
	cd ${WORKDIR}
	mv ${PN}_${vmaj}_${vmin}/${PN} . || die
	cd ${S}
}

src_install() {
	python_version
	distutils_src_install

	# docs
	cd ${S}
	dodoc README license.txt
	insinto /usr/share/doc/${PF}
	doins docs/*
}

pkg_postinst() {
	ewarn "There's a known bug with Verdana fonts inclusion."
	ewarn "    Don't use them: this will be fixed in the next version."
	ewarn ""
}
