# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/axel/axel-1.0b-r2.ebuild,v 1.4 2007/09/05 07:53:17 corsair Exp $

inherit eutils toolchain-funcs

DESCRIPTION="light Unix download accelerator"
HOMEPAGE="http://wilmer.gaast.net/main.php/axel.html"
SRC_URI="http://wilmer.gaast.net/downloads/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc-macos ppc64 ~sparc x86 ~x86-fbsd"
IUSE="debug nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Patch to fix buffer overflows #162005
	epatch "${FILESDIR}"/${P}-strcpy-fix.patch
	# Set LDFLAGS and fix expr
	sed -i -e 's/expr/& --/' -e "s/^LFLAGS=$/&${LDFLAGS}/" configure
}

src_compile() {
	local myconf

	use debug && myconf="--debug=1"
	use nls && myconf="--i18n=1"
	econf \
		--strip=0 \
		--etcdir=/etc \
		${myconf} \
		|| die

	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc API CHANGES CREDITS README axelrc.example
}

pkg_postinst() {
	einfo 'To use axel with portage, try these settings in your make.conf'
	einfo
	einfo ' FETCHCOMMAND="/usr/bin/axel -a -o \${DISTDIR}/\${FILE} \${URI}"'
	einfo ' RESUMECOMMAND="${FETCHCOMMAND}"'
}
