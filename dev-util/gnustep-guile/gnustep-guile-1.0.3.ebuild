# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/gnustep-guile/gnustep-guile-1.0.3.ebuild,v 1.3 2003/02/13 11:54:34 vapier Exp $

DESCRIPTION="GNUstep Guile bridge"
HOMEPAGE="http://www.gnustep.org"
SRC_URI="ftp://ftp.gnustep.org/pub/gnustep/libs/${P}.tar.gz"
LICENSE="LGPL"
SLOT="0"
KEYWORDS="x86 -ppc -sparc "
DEPEND=">=dev-util/gnustep-base-1.3.4
	>=dev-util/guile-1.4-r3"
RDEPEND="virtual/glibc"
S=${WORKDIR}/${P}

src_compile() {

	# Source GNUstep Makefiles
	. /usr/GNUstep/System/Makefiles/GNUstep.sh	

	# No options are needed to configure as environment variables 
	# are pulled from the GNUstep Makefiles
	./configure || die "configure failed"

	# Parallel builds fail on gnustep-base so I will follow suit here
	make || die "make failed"
}

src_install () {

	. /usr/GNUstep/System/Makefiles/GNUstep.sh

	cd ${WORKDIR}
	patch -p0 < ${FILESDIR}/installpath.diff
	cd ${S}

	make INSTALL_ROOT_DIR=${D} \
		GNUSTEP_INSTALLATION_DIR=${D}/usr/GNUstep/System \
		install || die "install failed"

}
