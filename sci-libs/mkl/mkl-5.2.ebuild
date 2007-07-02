# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/mkl/mkl-5.2.ebuild,v 1.3 2007/07/02 15:26:36 peper Exp $

S=${WORKDIR}
DESCRIPTION="Intel(R) Math Kernel Library"
HOMEPAGE="http://developer.intel.com/software/products/mkl/"
SRC_URI="http://developer.intel.com/software/products/mkl/downloads/mkl52lin_e.tar"

IUSE=""

# No need to, there aren't any executables and it takes a long time.
RESTRICT="strip"

SLOT="0"
LICENSE="imkl-5.1"
KEYWORDS="x86 -sparc"

DEPEND="app-arch/cpio
	app-arch/rpm"

RDEPEND=">=sys-kernel/linux-headers-2.4
	>=sys-libs/glibc-2.2.2"

src_compile() {
	mkdir opt

	for x in intel-*.i386.rpm
	do
		einfo "Extracting: ${x}"
		rpm2cpio ${x} | cpio --extract --make-directories --unconditional
	done
}

src_install () {
	cp -pPR opt ${D}
	cd ${D}/opt/intel/mkl/
	dodoc license.txt
	dohtml -r mklnotes.htm mkllic.htm doc/*
	rm -rf license.txt *.htm uninstall doc/

	# Mkl enviroment
	dodir /etc/env.d
	echo "LDPATH=/opt/intel/mkl/lib/32/" > ${D}/etc/env.d/35mkl
	echo "MKL_ROOT=/opt/intel/mkl"      >> ${D}/etc/env.d/35mkl
}
