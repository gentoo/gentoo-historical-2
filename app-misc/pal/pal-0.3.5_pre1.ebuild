# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pal/pal-0.3.5_pre1.ebuild,v 1.3 2006/10/14 13:46:34 tove Exp $

inherit toolchain-funcs

DESCRIPTION="pal command-line calendar program"
HOMEPAGE="http://palcal.sourceforge.net/"
SRC_URI="http://palcal.sourceforge.net/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE="ical"

RDEPEND=">=dev-libs/glib-2.0
	sys-libs/readline
	ical? ( dev-libs/libical )
	virtual/libintl"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	sys-devel/gettext"

S="${WORKDIR}/${P}/src"

src_compile() {
	emake \
		CC=$(tc-getCC) \
		OPT="${CFLAGS}" \
		|| die "emake failed"

	if useq ical; then
		cd convert
		emake \
			CC=$(tc-getCC) \
			OPT="${CFLAGS}" \
			ical \
			|| die "emake failed"
	fi
}

src_install() {
	make DESTDIR="${D}" install-no-rm || die "make install failed"

	if useq ical; then
		cd convert
		make DESTDIR="${D}" ical-install || die "make ical-install failed"
	fi

	cd ${WORKDIR}/${P}

	dodoc ChangeLog
}

