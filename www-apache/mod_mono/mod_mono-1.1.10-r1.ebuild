# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apache/mod_mono/mod_mono-1.1.10-r1.ebuild,v 1.2 2006/06/04 19:00:26 vericgar Exp $

inherit apache-module

DESCRIPTION="Apache module for Mono"
HOMEPAGE="http://www.go-mono.com/"
SRC_URI="http://www.go-mono.com/sources/${PN}/${P}.tar.gz"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="apache2"
DEPEND=">=dev-lang/mono-1.0
		>=dev-dotnet/xsp-${PV}"
RDEPEND="${DEPEND}"

APACHE1_MOD_FILE="${S}/src/.libs/mod_mono.so"
APACHE1_MOD_CONF="1.0.5-r1/70_mod_mono"
APACHE1_MOD_DEFINE="MONO"

APACHE2_MOD_FILE="${S}/src/.libs/mod_mono.so"
APACHE2_MOD_CONF="1.0.5-r1/70_mod_mono"
APACHE2_MOD_DEFINE="MONO"

DOCFILES="AUTHORS ChangeLog COPYING INSTALL NEWS README"

need_apache

pkg_setup() {
	ewarn "Some users are experiencing problems with mod_mono, where mod-mono-server"
	ewarn "will not start automatically, or requests will get a HTTP 500 application"
	ewarn "error.  If you experience these problems, please report it on:"
	ewarn
	ewarn "  http://bugs.gentoo.org/show_bug.cgi?id=77169"
	ewarn
	ewarn "with as much information as possible.  Thanks!"
}

src_compile() {
	econf || die "econf failed"

	emake || die "emake failed"
}

src_install() {
	mv src/.libs/mod_mono.so{.0.0.0,}
	apache-module_src_install
	doman man/mod_mono.8
}

pkg_postinst() {
	apache-module_pkg_postinst

	einfo "To view the samples, add \"-D MONO_DEMO\" at your apache's"
	einfo "conf.d configuration file."
}
