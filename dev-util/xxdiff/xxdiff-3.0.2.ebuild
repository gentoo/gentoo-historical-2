# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/xxdiff/xxdiff-3.0.2.ebuild,v 1.11 2004/07/31 07:17:24 kugelfang Exp $

inherit eutils

DESCRIPTION="A graphical file and directories comparator and merge tool."
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"
HOMEPAGE="http://xxdiff.sourceforge.net/"

DEPEND=">=x11-libs/qt-3.0.0
	=dev-util/tmake-1.8*
	kde? ( >=kde-base/kdelibs-3.1.0 )"

RDEPEND="sys-apps/diffutils"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ia64 alpha ~ppc ~amd64"
IUSE="kde"

src_unpack()
{
	unpack ${A}
	if use kde; then
		cd ${S}/src
		cp ${FILESDIR}/kdesupport.patch .
		sed -e "s:/usr/kde/3.1:`ls -d /usr/kde/* | tail -n 1`:g" -i kdesupport.patch
		epatch kdesupport.patch
	fi
}

src_compile() {
	cd src
	tmake -o Makefile xxdiff.pro

	### borrowed from kde.eclass #
	#
	# fix the sandbox errors "can't writ to .kde or .qt" problems.
	# this is a fake homedir that is writeable under the sandbox, so that the build
	# process can do anything it wants with it.
	REALHOME="$HOME"
	mkdir -p $T/fakehome/.kde
	mkdir -p $T/fakehome/.qt
	export HOME="$T/fakehome"
	addwrite "${QTDIR}/etc/settings"

	# things that should access the real homedir
	[ -d "$REALHOME/.ccache" ] && ln -sf "$REALHOME/.ccache" "$HOME/"

	emake || die
}

src_install () {
	dobin bin/xxdiff bin/xxdiff-cvs-diff bin/xxdiff-encrypted bin/xxdiff-find-grep-sed bin/xxdiff-match
	doman src/xxdiff.1
	dodoc README COPYING CHANGES TODO
}
