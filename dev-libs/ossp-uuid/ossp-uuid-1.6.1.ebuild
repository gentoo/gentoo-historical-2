# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/ossp-uuid/ossp-uuid-1.6.1.ebuild,v 1.3 2008/03/31 13:13:49 armin76 Exp $

EAPI="1"

PHP_EXT_NAME="uuid"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"

inherit eutils multilib php-ext-source-r1 depend.php

MY_P="uuid-${PV}"

DESCRIPTION="An ISO-C:1999 API and corresponding CLI for the generation of DCE 1.1, ISO/IEC 11578:1996 and RFC 4122 compliant UUID."
HOMEPAGE="http://www.ossp.org/pkg/lib/uuid/"
SRC_URI="ftp://ftp.ossp.org/pkg/lib/uuid/${MY_P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~sparc ~x86"
IUSE="cxx php"

DEPEND="php? ( dev-lang/php:5 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

need_php5_cli

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gentoo.patch"
}

src_compile() {
	# Notes:
	# * collides with e2fstools libs and includes if not moved around
	# * perl-bindings are broken
	# * pgsql-bindings need PostgreSQL-sources and are included since PostgreSQL 8.3
	econf \
		--includedir=/usr/include/ossp \
		--with-dce \
		--without-pgsql \
		--without-perl \
		--without-php \
		$(use_with cxx) \
		|| die "econf failed"
	emake || die "emake failed"

	if use php; then
		cd php
		php-ext-source-r1_src_compile
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS BINDINGS ChangeLog HISTORY NEWS OVERVIEW PORTING README SEEALSO THANKS TODO USERS

	if use php ; then
		cd php
		php-ext-source-r1_src_install
		insinto /usr/share/php5
		newins uuid.php5 uuid.php
	fi

	mv "${D}/usr/$(get_libdir)/pkgconfig"/{,ossp-}uuid.pc
	mv "${D}/usr/share/man/man3"/uuid.3{,ossp}
	mv "${D}/usr/share/man/man3"/uuid++.3{,ossp}
}

src_test() {
	emake check || die "emake check failed"
	# Tests for the php-bindings would be available
}
