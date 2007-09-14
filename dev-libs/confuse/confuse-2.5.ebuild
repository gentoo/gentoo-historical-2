# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/confuse/confuse-2.5.ebuild,v 1.26 2007/09/14 17:37:03 mr_bones_ Exp $

WANT_AUTOMAKE="1.8"

inherit eutils libtool autotools

DESCRIPTION="a configuration file parser library"
HOMEPAGE="http://www.nongnu.org/confuse/"
SRC_URI="http://savannah.nongnu.org/download/confuse/${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="doc debug nls test"

DEPEND="sys-devel/libtool
	dev-util/pkgconfig
	test? ( dev-libs/check )
	doc? ( app-text/openjade
		>=app-text/docbook-sgml-dtd-3.1-r1 )"
RDEPEND=""

src_unpack(){
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-maketest.patch

	# We should link to libintl correctly
	epatch "${FILESDIR}"/${P}-libintl.patch

	eautomake
	elibtoolize
}

src_compile() {
	local myconf

	use debug \
		&& myconf="${myconf} --enable-debug=all" \
		|| myconf="${myconf} --disable-debug"

	econf \
		--enable-shared \
		$(use_enable doc build-docs) \
		$(use_enable nls) \
		${myconf} || die
	emake || die
}

src_test() {
	cd "${S}"/tests
	./check_confuse || die "self test failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS NEWS README
	dobin confuse-config
	if use doc ; then
		dohtml doc/html/*.html || die
	fi
	rmdir "${D}"/usr/bin
}
