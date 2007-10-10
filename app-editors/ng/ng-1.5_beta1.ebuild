# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/ng/ng-1.5_beta1.ebuild,v 1.11 2007/10/10 07:12:42 opfer Exp $

inherit eutils

MY_P=${P/_beta/beta}

DESCRIPTION="Emacs like micro editor Ng -- based on mg2a"
HOMEPAGE="http://tt.sakura.ne.jp/~amura/ng/"
SRC_URI="http://tt.sakura.ne.jp/~amura/archives/ng/${MY_P}.tar.gz"

LICENSE="Emacs"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE="canna"

RDEPEND="virtual/libc
	>=sys-libs/ncurses-5.0
	canna? ( app-i18n/canna )"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4.0"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${S}
	epatch "${FILESDIR}/${MY_P}-ncurses.patch"
}

src_compile() {
	local myconf

	if use canna; then
		myconf="--enable-canna"
	fi
	econf ${myconf} || die
	sed -i -e "s/^#undef NO_BACKUP/#define NO_BACKUP/" config.h \
		|| die "sed failed"

	emake || die
}

src_install() {
	dobin ng || die
	dodoc docs/* MANIFEST dot.ng

	insinto /usr/share/ng
	doins bin/*

	insinto /etc/skel
	newins dot.ng .ng
}

pkg_postinst() {
	elog
	elog "If you want to use user Config"
	elog "cp /etc/skel/.ng ~/.ng"
	elog "and edit your .ng configuration file."
	elog
}
