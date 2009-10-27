# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/axel/axel-2.4.ebuild,v 1.1 2009/10/27 23:09:08 vostorga Exp $

inherit eutils toolchain-funcs

DESCRIPTION="light Unix download accelerator"
HOMEPAGE="http://axel.alioth.debian.org/"
SRC_URI="http://alioth.debian.org/frs/download.php/3015/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug kde nls"

RDEPEND="nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	kde? ( kde-misc/kaptain )"

#S="${WORKDIR}/${PN}-1.1"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Set LDFLAGS and fix expr
	sed -i -e 's/expr/& --/' -e "s/^LFLAGS=$/&${LDFLAGS}/" configure
}

src_compile() {
	local myconf

	use debug && myconf="${myconf} --debug=1"
	use nls && myconf="${myconf} --i18n=1"
	econf \
		--strip=0 \
		--etcdir=/etc \
		${myconf}

	emake CFLAGS="${CFLAGS}" CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if use kde; then
		dobin gui/kapt/axel-kapt || die
		doman gui/kapt/axel-kapt.1 || die
		domenu gui/kapt/axel-kapt.desktop || die
	fi

	dodoc API CHANGES CREDITS README axelrc.example
}

pkg_postinst() {
	einfo 'To use axel with portage, try these settings in your make.conf'
	einfo
	einfo ' FETCHCOMMAND='\''/usr/bin/axel -a -o "\${DISTDIR}/\${FILE}.axel" "\${URI}" && mv "\${DISTDIR}/\${FILE}.axel" "\${DISTDIR}/\${FILE}"'\'
	einfo ' RESUMECOMMAND="${FETCHCOMMAND}"'
}
