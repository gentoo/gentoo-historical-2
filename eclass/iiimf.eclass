# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/eclass/iiimf.eclass,v 1.6 2004/06/29 15:16:23 vapier Exp $
#
# Author: Mamoru KOMACHI <usata@gentoo.org>
#
# The IIIMF eclass is used for compilation and installation of IIIMF
# libraries, servers, clients and modules within the Portage system.
#

ECLASS=iiimf
INHERITED="$INHERITED $ECLASS"
EXPORT_FUNCTIONS src_compile src_install

IMSDK_PV="r${PV/./_}"
IMSDK_PN="im-sdk"
IMSDK_P="${IMSDK_PN}.${IMSDK_PV}"
IMSDK="${IMSDK_P//./-}"

DESCRIPTION="Based on the $ECLASS eclass"
HOMEPAGE="http://www.openi18n.org/subgroups/im/IIIMF/"
SRC_URI="http://www.openi18n.org/download/docs/im-sdk/${IMSDK_P}.tar.bz2"

LICENSE="MIT X11"
SLOT="0"
KEYWORDS="~x86"
IUSE="debug"

DEPEND="virtual/libc"

S="${WORKDIR}/${IMSDK}/${PN}"

iiimf_src_compile() {

	econf --enable-optimize \
		`use_enable debug` || die
	# emake doesn't work on some libraries
	make || die
}

iiimf_src_install() {

	einstall || die

	dodoc ChangeLog
}

