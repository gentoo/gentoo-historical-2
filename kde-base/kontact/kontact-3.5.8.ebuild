# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kontact/kontact-3.5.8.ebuild,v 1.2 2008/01/28 23:08:07 philantrop Exp $

KMNAME=kdepim
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

SRC_URI="${SRC_URI}
	mirror://gentoo/kdepim-3.5-patchset-04.tar.bz2"

DESCRIPTION="KDE personal information manager"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

DEPEND="$(deprange $PV $MAXKDEVER kde-base/libkdepim)
		$(deprange $PV $MAXKDEVER kde-base/libkpimidentities)"

RDEPEND="${DEPEND}"

KMCOPYLIB="libkdepim libkdepim/
	libkpimidentities.la libkpimidentities/"
KMEXTRACTONLY="libkdepim/
	libkpimidentities/
	kontact/plugins/"
KMEXTRA="
	kontact/plugins/newsticker/
	kontact/plugins/summary/
	kontact/plugins/weather/"
# We remove some plugins that are related to external kdepim programs,
# because they also need libs from korganizer, kpilot etc... so to emerge
# kontact we'd also need ALL the other programs, thus, it's better to emerge
# kontact's plugins in the ebuild of its program.

pkg_postinst() {
	kde_pkg_postinst

	elog "If you're using x11-misc/basket, please re-emerge it now to avoid crashes with ${PN}."
	elog "cf. https://bugs.gentoo.org/show_bug.cgi?id=174872 for details."
}
