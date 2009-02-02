# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdg-utils/xdg-utils-1.0.2-r2.ebuild,v 1.2 2009/02/02 18:49:12 scarabeus Exp $

inherit eutils

DESCRIPTION="Portland utils for cross-platform/cross-toolkit/cross-desktop interoperability"
HOMEPAGE="http://portland.freedesktop.org/wiki"
SRC_URI="http://portland.freedesktop.org/download/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc"

RESTRICT="test"

RDEPEND="x11-apps/xprop
	x11-misc/shared-mime-info"
PDEPEND="dev-util/desktop-file-utils"
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"/scripts
	epatch "${FILESDIR}"/${P}-arb-comm-exec.patch \
		"${FILESDIR}"/${P}-kdedirs.patch \
		"${FILESDIR}"/${P}-xdgopen-kde.patch
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed."
	dodoc ChangeLog README RELEASE_NOTES TODO
	newdoc scripts/README README.scripts
	use doc && dohtml -r scripts/html
}

pkg_postinst() {
	elog "Install >=x11-libs/gtk+-2 if you need command gtk-update-icon-cache."
}
