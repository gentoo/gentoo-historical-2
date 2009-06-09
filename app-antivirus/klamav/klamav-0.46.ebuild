# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/klamav/klamav-0.46.ebuild,v 1.7 2009/06/09 13:07:49 tampakrap Exp $

ARTS_REQUIRED="never"

inherit kde

MY_P="${P}-source"
S="${WORKDIR}/${MY_P}/${P}"

DESCRIPTION="KlamAV is a KDE frontend for the ClamAV antivirus."
HOMEPAGE="http://klamav.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="3.5"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

DEPEND=">=app-antivirus/clamav-0.90"
RDEPEND="${DEPEND}
	>=kde-base/kdebase-kioslaves-3.5.9"

need-kde 3.5

PATCHES=(
	"${FILESDIR}/klamav-0.43-desktop-entry.diff"
	)
src_unpack(){
	kde_src_unpack

	# Assure a future version won't try to build this.
	rm -rf "${WORKDIR}/${MY_P}/dazuko"* || die "We missed to eradicate some files"

	rm -f "${S}"/configure
}

src_compile(){
	# Disable updates from the GUI. We have package managers for that. cf. bug 171414
	myconf="--with-disableupdates"
	kde_src_compile
}

pkg_postinst(){
	kde_pkg_postinst

	elog "The on-access scanning functionality is provided by"
	elog "the Dazuko kernel module. To use it, install sys-fs/dazuko."
}
