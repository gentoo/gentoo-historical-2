# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/usermode-sources/usermode-sources-2.4.21.ebuild,v 1.3 2003/09/10 16:09:03 plasmaroo Exp $

UML_VERSION="${PV}"
UML_PATCH="uml-patch-2.4.21-1"

S=${WORKDIR}/linux-${PV}

# we patch against vanilla-sources only

DESCRIPTION="Full (vanilla) sources for the User Mode Linux kernel"
SRC_URI="http://www.kernel.org/pub/linux/kernel/v2.4/linux-${PV}.tar.bz2
mirror://sourceforge/user-mode-linux/${UML_PATCH}.bz2"
HOMEPAGE="http://www.kernel.org/ http://user-mode-linux.sourceforge.net"
LICENSE="GPL-2"
SLOT="${UML_VERSION}"
KEYWORDS="~x86 -ppc -sparc  -alpha"

#console-tools is needed to solve the loadkeys fiasco.
#binutils version needed to avoid Athlon/PIII/SSE assembler bugs.
DEPEND=">=sys-devel/binutils-2.11.90.0.31 dev-lang/perl"
RDEPEND=">=sys-libs/ncurses-5.2"

src_unpack() {

	cd ${WORKDIR}
	unpack linux-${PV}.tar.bz2
	if [ "${PV}" != "${UML_VERSION}" ]; then
		mv linux-${PV} linux-${UML_VERSION} || die
	fi
	cd ${S}
	bzcat ${DISTDIR}/${UML_PATCH}.bz2 | patch -p1
	echo "Preparing for compilation..."

	#fix silly permissions in tarball
	cd ${WORKDIR}
	chown -R 0.0 *
	chmod -R a+r-w+X,u+w *

}

src_compile() {
	ewarn "Nothing to compile.  That's up to the user"
}

src_install() {
		mkdir -p ${D}/usr/src/uml
		cd ${WORKDIR}
		mv linux-${UML_VERSION} ${D}/usr/src/uml/
}


