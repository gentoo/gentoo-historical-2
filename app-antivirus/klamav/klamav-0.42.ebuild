# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-antivirus/klamav/klamav-0.42.ebuild,v 1.5 2008/02/10 10:20:17 maekke Exp $

inherit kde

MY_P="${P}-source"
S="${WORKDIR}/${MY_P}/${P}"

DESCRIPTION="KlamAV is a KDE frontend for the ClamAV antivirus."
HOMEPAGE="http://klamav.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ppc ppc64 ~sparc x86"
IUSE=""

DEPEND=">=app-antivirus/clamav-0.90"
RDEPEND="${DEPEND}"

need-kde 3.5

PATCHES="${FILESDIR}/${PN}-0.41-cl_loaddbdir.patch"

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
	elog "The on-access scanning functionality is provided by"
	elog "the Dazuko kernel module:  emerge sys-fs/dazuko"
}
