# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# /space/gentoo/cvsroot/gentoo-x86/dev-libs/tinyqt/tinyqt-3.0.3.ebuild,v 1.3 2002/04/27 10:31:46 seemant Exp

DESCRIPTION="Stripped down version of qt ${PV} for console development"
SLOT="3"
S=${WORKDIR}/${P}
SRC_URI="mirror://sourceforge/tinyqt/tinyq-${PV}.tar.bz2"
HOMEPAGE="http://www.uwyn.com/projects/tinyq"

DEPEND="virtual/glibc
	>=sys-devel/gcc-2.95.3-r5
	>=dev-util/yacc-1.9.1-r1
	>=sys-devel/flex-2.5.4a-r4"

QTBASE=/usr/qt/tinyq
export QTDIR=${S}

src_compile() {

	./configure -release -no-g++-exceptions -prefix /usr/qt/tinyq || die
	emake || die
}

src_install() {

	make INSTALL_ROOT=${D} install || die
	insinto /etc/env.d
	doins ${FILESDIR}/47tinyq

}
