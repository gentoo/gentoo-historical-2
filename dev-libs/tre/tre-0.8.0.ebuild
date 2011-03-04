# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/tre/tre-0.8.0.ebuild,v 1.12 2011/03/04 17:55:51 jlec Exp $

EAPI=2

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils eutils

DESCRIPTION="Lightweight, robust, and efficient POSIX compliant regexp matching library"
HOMEPAGE="http://laurikari.net/tre/"
SRC_URI="http://laurikari.net/tre/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ~ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="nls python static-libs"

RDEPEND="
	!app-misc/glimpse
	!app-text/agrep"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	nls? ( sys-devel/gettext )"

DISTUTILS_SETUP_FILES=("python/setup.py")

src_prepare() {
	epatch "${FILESDIR}"/${PV}-python.patch
}

src_configure() {
	econf \
		--disable-dependency-tracking \
		--enable-agrep \
		--enable-system-abi \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

src_compile() {
	emake || die
	use python && distutils_src_compile
}

src_test() {
	if $(locale -a | grep -iq en_US.iso88591); then
	emake -j1 \
		check || die
	else
		ewarn "If you like to run the test,"
		ewarn "please make sure en_US.ISO-8859-1 is installed."
		die "en_US.ISO-8859-1 locale is missing"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README THANKS TODO || die
	dohtml doc/*.{css,html} || die
	use python && distutils_src_install
}

pkg_postinst() {
	echo
	ewarn "app-misc/glimpse, app-text/agrep and this package all provide agrep."
	ewarn "If this causes any unforeseen incompatibilities please file a bug"
	ewarn "on http://bugs.gentoo.org."
	echo
}
