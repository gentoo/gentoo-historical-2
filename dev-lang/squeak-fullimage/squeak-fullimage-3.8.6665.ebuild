# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/squeak-fullimage/squeak-fullimage-3.8.6665.ebuild,v 1.4 2010/01/02 18:40:38 fauli Exp $

MY_P="Squeak3.8-6665"
DESCRIPTION="Squeak full image file"
HOMEPAGE="http://www.squeak.org/"
SRC_URI="http://ftp.squeak.org/current_stable/${MY_P}-full.zip
		http://ftp.squeak.org/current_stable/SqueakV3.sources.gz"

LICENSE="Apple"
SLOT="3.8"
KEYWORDS="~x86 ~x86-linux ~ppc-macos"
IUSE=""
PROVIDE="virtual/squeak-image"

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}"

src_compile() {
	einfo "Compressing image/changes files."
	gzip ${MY_P}full.image
	gzip ${MY_P}full.changes
	einfo "done."
}

src_install() {
	einfo 'Installing Image/Sources/Changes files.'
	dodoc ReadMe.txt
	insinto /usr/lib/squeak
	# install full image and changes file.
	doins ${MY_P}full.image.gz
	doins ${MY_P}full.changes.gz
	# install sources
	doins SqueakV3.sources
	# create symlinks to the changes and image files.
	dosym /usr/lib/squeak/${MY_P}full.changes.gz \
		/usr/lib/squeak/squeak.changes.gz
	dosym /usr/lib/squeak/${MY_P}full.image.gz \
		/usr/lib/squeak/squeak.image.gz
}

pkg_postinst() {
	elog "Squeak ${PV} image, changes and sources files installed in /usr/lib/squeak"
}
