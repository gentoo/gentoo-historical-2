# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-power/iasl/iasl-20050513.ebuild,v 1.1 2005/06/17 11:04:15 brix Exp $

inherit toolchain-funcs

MY_P=acpica-unix-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Intel ACPI Source Language (ASL) compiler"
HOMEPAGE="http://www.intel.com/technology/iapc/acpi/"
SRC_URI="http://www.intel.com/technology/iapc/acpi/downloads/${MY_P}.tar.gz"

LICENSE="iASL"
SLOT="0"
KEYWORDS="~x86"

IUSE=""
DEPEND="sys-devel/bison
		sys-devel/flex"
RDEPEND=""

src_compile() {
	cd ${S}/compiler
	emake -j1 CC=$(tc-getCC) || die "emake failed"
}

src_install() {
	dobin compiler/iasl

	dodoc ${S}/README
}
