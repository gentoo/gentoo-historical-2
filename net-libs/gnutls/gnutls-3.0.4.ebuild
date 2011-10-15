# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/gnutls/gnutls-3.0.4.ebuild,v 1.1 2011/10/15 19:59:41 radhermit Exp $

EAPI=4

inherit autotools libtool

DESCRIPTION="A TLS 1.2 and SSL 3.0 implementation for the GNU project"
HOMEPAGE="http://www.gnutls.org/"

if [[ "${PV}" == *pre* ]]; then
	SRC_URI="http://daily.josefsson.org/${P%.*}/${P%.*}-${PV#*pre}.tar.gz"
else
	MINOR_VERSION="${PV#*.}"
	MINOR_VERSION="${MINOR_VERSION%%.*}"
	if [[ $((MINOR_VERSION % 2)) == 0 ]]; then
		#SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.bz2"
		SRC_URI="mirror://gnu/${PN}/${P}.tar.xz"
	else
		SRC_URI="ftp://alpha.gnu.org/gnu/${PN}/${P}.tar.xz"
	fi
	unset MINOR_VERSION
fi

# LGPL-2.1 for libgnutls library and GPL-3 for libgnutls-extra library.
LICENSE="GPL-3 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd"
IUSE="+cxx doc examples guile +nettle nls pkcs11 static-libs test zlib"

# lib/m4/hooks.m4 says that GnuTLS uses a fork of PaKChoiS.
RDEPEND="
	>=dev-libs/libtasn1-0.3.4
	>=dev-libs/nettle-2.2[gmp]
	guile? ( >=dev-scheme/guile-1.8[networking] )
	nls? ( virtual/libintl )
	pkcs11? ( app-crypt/p11-kit )
	zlib? ( >=sys-libs/zlib-1.2.3.1 )"
DEPEND="${RDEPEND}
	sys-devel/libtool
	doc? ( dev-util/gtk-doc )
	nls? ( sys-devel/gettext )
	test? ( app-misc/datefudge )"

S="${WORKDIR}/${P%_pre*}"

DOCS=( AUTHORS ChangeLog NEWS README THANKS doc/TODO )

src_prepare() {
	local dir

	# tests/suite directory is not distributed.
	sed -i \
		-e ':AC_CONFIG_FILES(\[tests/suite/Makefile\]):d' \
		configure.ac || die

	sed -i \
		-e 's/imagesdir = $(infodir)/imagesdir = $(htmldir)/' \
		doc/Makefile.am || die

	for dir in m4 gl/m4; do
		rm -f "${dir}/lt"* "${dir}/libtool.m4"
	done
	find . -name ltmain.sh -exec rm {} \;
	eautoreconf

	# Use sane .so versioning on FreeBSD.
	elibtoolize
}

src_configure() {
	local myconf
	[[ ${VALGRIND_TESTS} != 1 ]] && myconf+=" --disable-valgrind-tests"

	econf \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		$(use_enable static-libs static) \
		$(use_enable cxx) \
		$(use_enable doc gtk-doc) \
		$(use_enable doc gtk-doc-pdf) \
		$(use_enable guile) \
		$(use_enable nls) \
		$(use_with pkcs11 p11-kit) \
		$(use_with zlib) \
		${myconf}
}

src_test() {
	if has_version dev-util/valgrind && [[ ${VALGRIND_TESTS} != 1 ]]; then
		elog
		elog "You can set VALGRIND_TESTS=\"1\" to enable Valgrind tests."
		elog
	fi

	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +

	if use doc; then
		dodoc doc/gnutls.{pdf,ps}
		dohtml doc/gnutls.html
	fi

	if use examples; then
		docinto examples
		dodoc doc/examples/*.c
	fi
}
