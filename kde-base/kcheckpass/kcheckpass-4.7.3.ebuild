# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kcheckpass/kcheckpass-4.7.3.ebuild,v 1.3 2011/12/07 22:13:49 hwoarang Exp $

EAPI=4

KMNAME="kde-workspace"
inherit kde4-meta

DESCRIPTION="A simple password checker, used by any software in need of user authentication."
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug pam"

RDEPEND="
	pam? (
		>=kde-base/kdebase-pam-7
		virtual/pam
	)
"
DEPEND="${RDEPEND}
	x11-libs/libxkbfile
"

PATCHES=(
	"${FILESDIR}/kdebase-4.0.2-pam-optional.patch"
)

src_prepare() {
	kde4-meta_src_prepare

	use pam && epatch "${FILESDIR}/${PN}-4.4.2-no-SUID-no-GUID.patch"
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_with pam)
	)

	kde4-meta_src_configure
}
