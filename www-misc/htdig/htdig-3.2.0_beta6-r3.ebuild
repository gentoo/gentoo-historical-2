# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/htdig/htdig-3.2.0_beta6-r3.ebuild,v 1.4 2007/12/04 10:59:13 armin76 Exp $

inherit eutils autotools

MY_PV=${PV/_beta/b}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="HTTP/HTML indexing and searching system"
SRC_URI="http://www.htdig.org/files/${PN}-${MY_PV}.tar.gz"
HOMEPAGE="http://www.htdig.org"
KEYWORDS="alpha amd64 ~hppa ia64 ~mips ~ppc ~ppc64 sparc x86 ~x86-fbsd"
LICENSE="GPL-2"

DEPEND=">=sys-libs/zlib-1.1.3
	app-arch/unzip
	ssl? ( dev-libs/openssl )"

IUSE="ssl"
SLOT="0"

src_unpack() {
	unpack "${A}"

	cd "${S}"
	epatch "${FILESDIR}/${P}"-gcc4.patch
	epatch "${FILESDIR}/${P}"-as-needed.patch
	epatch "${FILESDIR}/${P}"-quoting.patch
	eautoreconf
}

src_compile() {
	local conf="
		--with-config-dir=/etc/${PN} \
		--with-default-config-file=/etc/${PN}/${PN}.conf \
		--with-database-dir=/var/lib/${PN}/db \
		--with-cgi-bin-dir=/var/www/localhost/cgi-bin \
		--with-search-dir=/var/www/localhost/htdocs/${PN} \
		--with-image-dir=/var/www/localhost/htdocs/${PN}
	"
	use ssl && conf="${conf} --with-ssl"

	econf ${conf} || die "configure failed"

#		--with-image-url-prefix=file:///var/www/localhost/htdocs/${PN} \

	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "make install failed"

	dodoc ChangeLog README
	dohtml -r htdoc

	dosed /etc/${PN}/${PN}.conf
	dosed /usr/bin/rundig

	# symlink htsearch so it can be easily found. see bug #62087
	dosym /var/www/localhost/cgi-bin/htsearch /usr/bin/htsearch
}
