# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/guile/guile-1.6.4-r2.ebuild,v 1.2 2005/01/28 11:03:43 liquidx Exp $

inherit flag-o-matic eutils

DESCRIPTION="Scheme interpreter"
HOMEPAGE="http://www.gnu.org/software/guile/"
SRC_URI="mirror://gnu/guile/${P}.tar.gz"

LICENSE="GPL-2"
# This version is only necessary for using gnucash on amd64.
KEYWORDS="-* ~amd64"
IUSE=""

DEPEND=">=sys-libs/ncurses-5.1
	>=sys-libs/readline-4.1"

# NOTE: in README-PACKAGERS, guile recommends different versions be installed
#       in parallel. They're talking about LIBRARY MAJOR versions and not
#       the actual guile version that was used in the past.
#
#       So I'm slotting this as 12 beacuse of the library major version
SLOT="12"
MAJOR="1.6"

src_compile() {
	# Fix for bug 26484: This package fails to build when built with
	# -g3, at least on some architectures.  (19 Aug 2003 agriffis)
	filter-flags -g3

	if [ "${ARCH}" = "amd64" ]; then
		epatch ${FILESDIR}/guile-amd64.patch
	fi

	econf \
		--with-threads \
		--with-modules \
		--enable-deprecation=no || die
	# Please keep --enable-deprecation=no in future bumps.
	# Danny van Dyk <kugelfang@gentoo.org 2004/09/19

	# Problems with parallel builds (#34029), so I'm taking the safer route
	emake -j1 || die
}

src_install() {
	einstall || die
	dodoc AUTHORS ChangeLog GUILE-VERSION HACKING NEWS README SNAPSHOTS THANKS
	#texmacs needs this, closing bug #23493
	dodir /etc/env.d
	#We don't slot the env.d entry because /usr/bin/guile-config is there anyway,
	#and will only match the last guile installed. so the GUILE_LOAD_PATH will
	#match the data available from guile-config.
	echo "GUILE_LOAD_PATH=\"/usr/share/guile/${MAJOR}\"" > ${D}/etc/env.d/50guile
}
