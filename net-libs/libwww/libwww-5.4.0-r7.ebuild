# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libwww/libwww-5.4.0-r7.ebuild,v 1.9 2006/11/04 12:03:19 blubb Exp $

WANT_AUTOMAKE="latest"
WANT_AUTOCONF="latest"
inherit eutils multilib autotools

PATCHVER="1.0"
MY_P=w3c-${P}
DESCRIPTION="A general-purpose client side WEB API"
HOMEPAGE="http://www.w3.org/Library/"
SRC_URI="http://www.w3.org/Library/Distribution/${MY_P}.tgz
	mirror://gentoo/${P}-patches-${PATCHVER}.tar.bz2"

LICENSE="W3C"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="mysql ssl"

RDEPEND=">=sys-libs/zlib-1.1.4
	mysql? ( >=dev-db/mysql-3.23.26 )
	ssl? ( >=dev-libs/openssl-0.9.6 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	!dev-libs/9libs
	dev-lang/perl"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -f configure.in
	EPATCH_SUFFIX="patch" epatch "${WORKDIR}"/patch
	eautoreconf || die "autoreconf failed"
}

src_compile() {
	if use mysql ; then
		myconf="--with-mysql=/usr/$(get_libdir)/mysql/libmysqlclient.a"
	else
		myconf="--without-mysql"
	fi

	export ac_cv_header_appkit_appkit_h=no
	econf \
		--enable-shared \
		--enable-static \
		--with-zlib \
		--with-md5 \
		--with-expat \
		$(use_with ssl) \
		${myconf} || die "./configure failed"

	emake || die "Compilation failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "Installation failed"
	dodoc ChangeLog
	dohtml -r .
}
