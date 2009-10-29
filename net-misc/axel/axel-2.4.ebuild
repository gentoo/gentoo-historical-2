# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/axel/axel-2.4.ebuild,v 1.3 2009/10/29 18:29:29 tommy Exp $

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="Light Unix download accelerator"
HOMEPAGE="http://axel.alioth.debian.org/"
SRC_URI="http://alioth.debian.org/frs/download.php/3016/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="debug nls"

DEPEND="nls? ( sys-devel/gettext )"
RDEPEND="nls? ( virtual/libintl )"

src_prepare() {
	sed -i -e "s/^LFLAGS=$/&${LDFLAGS}/" configure || die "sed failed"
}

src_configure() {
	local myconf=""

	use debug && myconf+=" --debug=1"
	use nls && myconf+=" --i18n=$(use nls && echo 1 || echo 0)"
	econf \
		--strip=0 \
		${myconf}
}

src_compile() {
	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc API CHANGES CREDITS README axelrc.example || die "dodoc failed"
}

pkg_postinst() {
	einfo 'To use axel with portage, try these settings in your make.conf'
	einfo
	einfo ' FETCHCOMMAND='\''/usr/bin/axel -a -o "\${DISTDIR}/\${FILE}.axel" "\${URI}" && mv "\${DISTDIR}/\${FILE}.axel" "\${DISTDIR}/\${FILE}"'\'
	einfo ' RESUMECOMMAND="${FETCHCOMMAND}"'
}
