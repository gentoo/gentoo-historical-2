# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/emelfm2/emelfm2-0.3.4.ebuild,v 1.5 2007/07/30 12:09:21 corsair Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A file manager that implements the popular two-pane design"
HOMEPAGE="http://emelfm2.net"
SRC_URI="http://${PN}.net/rel/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc64 ~sparc ~x86"
IUSE="unicode fam"

RESTRICT="test"

DEPEND=">=x11-libs/gtk+-2.6
		fam? ( virtual/fam )"
RDEPEND="${DEPEND}"

src_compile() {
	local myconf

	if use unicode; then
		myconf="FILES_UTF8ONLY=1"
	fi

	if use fam; then
		if has_version "app-admin/gamin"; then
			myconf="${myconf} USE_GAMIN=1"
		else
			myconf="${myconf} USE_FAM=1"
		fi
	else
		myconf="${myconf} USE_FAM=0"
	fi

	emake ICONDIR="/usr/share/pixmaps" \
		PREFIX="/usr" CC="$(tc-getCC) ${CFLAGS}" \
		${myconf} || die "emake failed."
}

src_install() {
	emake ICONDIR="${D}"/usr/share/pixmaps \
		PREFIX="${D}"/usr install || die "emake install failed."
	prepalldocs
}
