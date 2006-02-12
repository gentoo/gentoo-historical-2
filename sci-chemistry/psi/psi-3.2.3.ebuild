# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/psi/psi-3.2.3.ebuild,v 1.1 2006/02/12 06:04:10 spyderous Exp $

inherit autotools eutils

DESCRIPTION="Suite of ab initio quantum chemistry programs to compute various molecular properties"
HOMEPAGE="http://www.psicode.org/"
SRC_URI="mirror://sourceforge/psicode/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND="virtual/blas
	virtual/lapack
	sci-libs/libint"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}${PV:0:1}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/try-more-compilers.patch
	epatch ${FILESDIR}/try-pthread-for-blas-lapack.patch
	epatch ${FILESDIR}/dont-build-libint.patch
	epatch ${FILESDIR}/use-external-libint.patch
	eautoreconf
}

src_compile() {
	# This variable gets set sometimes to /usr/lib/src and breaks stuff
	unset CLIBS

	econf \
		--with-opt="${CFLAGS}" \
		--datadir=/usr/share/${PN} \
		|| die "configure failed"
	emake \
		SCRATCH="${WORKDIR}/libint" \
		|| die "make failed"
}

src_install() {
	einstall \
		datadir=${D}/usr/share/${PN} \
		docdir=${D}/usr/share/doc/${PF} \
		|| die "install failed"
}
