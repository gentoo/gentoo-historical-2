# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-cluster/maui/maui-3.2.6_p13-r1.ebuild,v 1.1 2005/07/05 20:20:09 robbat2 Exp $

DESCRIPTION="Maui Cluster Scheduler"
HOMEPAGE="http://www.clusterresources.com/products/maui/"
SRC_URI="http://www.clusterresources.com/downloads/maui/${P/_/}.tar.gz"
IUSE=""
DEPEND="virtual/pbs"
RDEPEND="${DEPEND}
		 virtual/libc"
SLOT="0"
LICENSE="maui"
KEYWORDS="~x86"
RESTRICT="fetch nomirror"

S="${WORKDIR}/${P/_/}"

src_compile() {
	econf --with-spooldir=/usr/spool/maui --with-pbs || die "econf failed!"

	# Torque on Gentoo installs libnet.a, which clobbers libnet.a from libnet.
	# (Stupid developers.) Unfortunately, libnet also installs libnet.so, which
	# Torque doesn't clobber, so when running make we end up linking against 
	# .so rather than .a. Big problem. Fix it.

	sed -i -e "s~-lnet~/usr/$(get_libdir)/pbs/libnet.a~" Makefile
	sed -i -e "s~BUILDROOT=~BUILDROOT=${D}~" Makefile
	emake || die "emake failed!"
}

src_install() {
	make install INST_DIR=${D}/usr

	cd docs
	dodoc README mauidocs.html
}
