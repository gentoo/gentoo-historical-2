# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-libs/clipper/clipper-20091215.ebuild,v 1.3 2010/04/05 18:05:41 jlec Exp $

EAPI="3"

WANT_AUTOMAKE="1.11"

inherit autotools eutils flag-o-matic

DESCRIPTION="Object-oriented libraries for the organisation of crystallographic data and the performance of crystallographic computation"
HOMEPAGE="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper.html"
# Transform 4-digit year to 2 digits
SRC_URI="http://www.ysbl.york.ac.uk/~cowtan/clipper/clipper-2.1-${PV:2:${#PV}}-ac.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

RDEPEND="
	sci-libs/ccp4-libs
	sci-libs/fftw
	sci-libs/mmdb"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}-2.1

src_prepare() {
	epatch "${FILESDIR}"/${PV}-missing-var.patch

	# ccp4 provides these, and more.
	sed -i -e "s:examples::g" "${S}"/Makefile.am

	AT_M4DIR="config" eautoreconf
}

src_configure() {
	# Recommended on ccp4bb/coot ML to fix crashes when calculating maps
	# on 64-bit systems
	append-flags -fno-strict-aliasing

	econf \
		--enable-ccp4 \
		--enable-cif \
		--enable-cns \
		--enable-contrib \
		--enable-minimol \
		--enable-mmdb \
		--enable-phs \
		--with-mmdb="${EPREFIX}"/usr \
		$(use_enable debug)
}

src_test() {
	emake \
		-C examples \
		check || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README ChangeLog NEWS || die
}
